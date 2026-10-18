/// Composition root + app-wide state. Wires the platform seams (billing,
/// speech, audio, haptics, push) to core logic exactly once, here.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/data/curriculum.dart';
import '../core/economy/content_gate.dart';
import '../core/events/analytics.dart';
import '../core/hangul/hangul.dart';
import '../platform/audio/audio_asset_manager.dart';
import '../platform/billing/billing.dart';
import '../platform/device/device.dart';
import '../platform/speech/ios_speech_recognizer.dart';
import '../platform/speech/pronunciation_scorer.dart';
import '../platform/speech/speech.dart';
import 'progress_store.dart';

class AppServices {
  AppServices({
    required this.billing,
    required this.speech,
    required this.scorer,
    required this.audio,
    required this.haptics,
    required this.push,
    required this.analytics,
    required this.channel,
  }) : assert(BillingConfig.isValidPairing(channel, billing),
            'store build paired with non-store billing gateway');

  final BillingGateway billing;
  final SpeechRecognizer speech;
  final PronunciationScorer scorer;
  final AudioAssetManager audio;
  final HapticsDriver haptics;
  final PushDriver push;
  final Analytics analytics;
  final BuildChannel channel;

  /// Dev-time default wiring. Release builds construct this per channel.
  /// [audio] override lets main() supply the bundled-asset manager while
  /// tests keep the log-only [DevAudioManager].
  factory AppServices.dev({AudioAssetManager? audio}) => AppServices(
        billing: BillingConfig.gatewayFor(BuildChannel.dev),
        speech: FakeSpeechRecognizer(scriptedTranscript: '안녕'),
        scorer: const JamoSimilarityScorer(),
        audio: audio ?? DevAudioManager(),
        haptics: NoopHaptics(),
        push: NoopPush(),
        analytics: LocalAnalytics(),
        channel: BuildChannel.dev,
      );

  /// App Store release wiring: StoreKit 2 + on-device Speech over the
  /// platform channels in ios/Runner/. [audio] must be an initialized
  /// [BundledAudioManager] (main() owns the async init).
  factory AppServices.appStore({required AudioAssetManager audio}) =>
      AppServices(
        billing: BillingConfig.gatewayFor(BuildChannel.appStore),
        speech: IosSpeechRecognizer(),
        scorer: const JamoSimilarityScorer(),
        audio: audio,
        haptics: FlutterHaptics(),
        push: LocalNotificationPush(),
        analytics: LocalAnalytics(), // vendor SDK swaps in at launch
        channel: BuildChannel.appStore,
      );
}

class AppState extends ChangeNotifier {
  AppState({required this.services, required this.store}) {
    _statusSub = services.billing.statusStream.listen((status) {
      _subscription = status;
      notifyListeners();
      unawaited(store.save());
    });
  }

  final AppServices services;
  final ProgressStore store;
  final ContentGate gate = const ContentGate();

  StreamSubscription<SubscriptionStatus>? _statusSub;
  SubscriptionStatus _subscription = SubscriptionStatus.none;
  bool _speechAvailable = false;

  ProgressState get progress => store.state;
  SubscriptionStatus get subscription => _subscription;
  bool get isPremium => _subscription.isActive;

  Future<void> init() async {
    await store.load();
    _speechAvailable = await services.speech.isAvailable();
    _subscription = await services.billing.restore();
    notifyListeners();
  }

  EntitlementState get entitlements => EntitlementState(
        isPremium: isPremium,
        reviewTeasersUsedToday: progress.teasersUsedToday(),
        speechAvailable: _speechAvailable,
      );

  // -- gameplay callbacks ---------------------------------------------------

  void completeOnboarding(int durationSec) {
    progress.onboardingDone = true;
    services.analytics
        .logEvent(Events.onboardingComplete, {'duration_sec': durationSec});
    unawaited(store.save());
    notifyListeners();
  }

  void onStageStart(StageId stage, int level) {
    services.analytics
        .logEvent(Events.stageStart, {'stage': stage.name, 'level': level});
  }

  /// Central post-round bookkeeping: level clear, XP, streak, codex unlocks,
  /// SRS feed, 7-day tracker event. Returns newly unlocked codex jamo ids.
  List<String> onStageComplete({
    required StageId stage,
    required int level,
    required int stars,
    required int points,
    required int mistakes,
    required List<String> touchedJamoIds,
  }) {
    progress.markCleared(stage.name, level);
    progress.xp += points;
    final streakGrew = progress.touchStreak();
    if (streakGrew) {
      unawaited(services.audio.playSlot(AudioSlots.streak));
    }

    final newCards = <String>[];
    for (final id in touchedJamoIds) {
      if (progress.unlockCodex(id)) {
        newCards.add(id);
        services.analytics.logEvent(Events.codexUnlock,
            {'jamo': id, 'total_unlocked': progress.codex.length});
      }
      // Mastery: 5-streak on the item marks the card mastered.
      if (progress.errors.statsFor(id).streak >=
          ErrorTrackerTuning.masteryStreak) {
        progress.masterCodex(id);
      }
    }

    services.analytics.logEvent(Events.stageComplete, {
      'stage': stage.name,
      'level': level,
      'stars': stars,
      'mistakes': mistakes,
    });
    _logTrackerProgress();
    unawaited(store.save());
    notifyListeners();
    return newCards;
  }

  void _logTrackerProgress() {
    final s1 = progress.cleared(StageId.jamoHunt.name);
    final s2 = progress.cleared(StageId.blockBuilder.name);
    for (final day in sevenDayTracker) {
      final pct = trackerDayProgress(day, s1, s2);
      if (pct >= 1.0) continue;
      services.analytics.logEvent(Events.sevenDayProgress,
          {'day': day.day, 'pct': (pct * 100).round()});
      break; // only the first incomplete day is "current"
    }
  }

  /// Current 7-day tracker day (1-based) and its progress.
  (TrackerDay, double) trackerNow() {
    final s1 = progress.cleared(StageId.jamoHunt.name);
    final s2 = progress.cleared(StageId.blockBuilder.name);
    for (final day in sevenDayTracker) {
      final pct = trackerDayProgress(day, s1, s2);
      if (pct < 1.0) return (day, pct);
    }
    return (sevenDayTracker.last, 1.0);
  }

  // -- review teaser --------------------------------------------------------

  bool startReviewSession() {
    final decision = gate.canStartReview(entitlements);
    if (!decision.allowed) return false;
    if (!isPremium) {
      progress.useTeaser();
      services.analytics.logEvent(Events.reviewTeaserUsed,
          {'streak_of_use': progress.reviewTeasersUsedToday});
      unawaited(store.save());
    }
    notifyListeners();
    return true;
  }

  // -- paywall --------------------------------------------------------------

  void logPaywallShown(String trigger) {
    services.analytics
        .logEvent(Events.paywallShown, {'trigger': trigger, 'variant': 'v1'});
  }

  Future<PurchaseResult> purchase(Product product) async {
    final result = await services.billing.purchase(product);
    if (result.success) {
      services.analytics.logEvent(
          result.isTrial ? Events.trialStart : Events.subscribe,
          {'plan': product.plan.name, 'price_tier': product.id});
      _subscription = await services.billing.restore();
      notifyListeners();
    }
    return result;
  }

  // -- audio conveniences ---------------------------------------------------

  Future<void> playJamo(Jamo j) => services.audio.playVoice(AudioSlots.jamo(j));
  Future<void> playSyllable(Syllable s) =>
      services.audio.playVoice(AudioSlots.syllable(s));
  Future<void> playWord(String wordId) =>
      services.audio.playVoice(AudioSlots.word(wordId));

  @override
  void dispose() {
    _statusSub?.cancel();
    super.dispose();
  }
}

/// Tuning constants shared between adaptive layer and codex mastery.
class ErrorTrackerTuning {
  static const masteryStreak = 5;
}
