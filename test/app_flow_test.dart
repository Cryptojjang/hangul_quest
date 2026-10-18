/// End-to-end headless play flow: onboarding → stage 1 → stage 2 free run →
/// hit the premium wall → mock purchase → wall opens → review teaser →
/// event log sanity. Mirrors the real screen flow without widgets.
library;

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/core/data/curriculum.dart';
import 'package:hangul_quest/core/economy/content_gate.dart';
import 'package:hangul_quest/core/events/analytics.dart';
import 'package:hangul_quest/core/game/round_engine.dart';
import 'package:hangul_quest/platform/audio/audio_asset_manager.dart';
import 'package:hangul_quest/platform/billing/billing.dart';
import 'package:hangul_quest/platform/device/device.dart';
import 'package:hangul_quest/platform/speech/pronunciation_scorer.dart';
import 'package:hangul_quest/platform/speech/speech.dart';
import 'package:hangul_quest/state/app_state.dart';
import 'package:hangul_quest/state/progress_store.dart';

AppState buildApp({SpeechRecognizer? speech}) {
  final services = AppServices(
    billing: MockBillingGateway(),
    speech: speech ?? FakeSpeechRecognizer(scriptedTranscript: '안녕'),
    scorer: const JamoSimilarityScorer(),
    audio: DevAudioManager(),
    haptics: NoopHaptics(),
    push: NoopPush(),
    analytics: LocalAnalytics(),
    channel: BuildChannel.dev,
  );
  return AppState(
      services: services, store: ProgressStore(InMemoryStorage()));
}

LocalAnalytics logOf(AppState s) => s.services.analytics as LocalAnalytics;

void main() {
  test('full free-to-premium play flow', () async {
    final app = buildApp();
    await app.init();

    // -- onboarding ---------------------------------------------------------
    expect(app.progress.onboardingDone, isFalse);
    app.completeOnboarding(42);
    expect(app.progress.onboardingDone, isTrue);
    expect(logOf(app).log.first.name, Events.onboardingComplete);

    // -- stage 1 level 1: perfect run ---------------------------------------
    app.onStageStart(StageId.jamoHunt, 1);
    final tracker = app.progress.errors;
    final round1 = JamoHuntRound(
        level: stage1Levels[0], tracker: tracker, random: Random(1));
    while (!round1.finished) {
      round1.answer(round1.current!.answer,
          secondsLeft: 3, tracker: tracker);
    }
    final newCards = app.onStageComplete(
      stage: StageId.jamoHunt,
      level: 1,
      stars: round1.score.stars,
      points: round1.score.points,
      mistakes: round1.score.wrong,
      touchedJamoIds:
          round1.questions.map((q) => q.answer.id).toSet().toList(),
    );
    expect(newCards, isNotEmpty, reason: 'first play unlocks codex cards');
    expect(app.progress.cleared(StageId.jamoHunt.name), 1);
    expect(app.progress.streakDays, 1);
    expect(app.progress.xp, greaterThan(0));

    // codex events fired
    expect(logOf(app).log.any((e) => e.name == Events.codexUnlock), isTrue);
    // 7-day tracker progress logged
    expect(
        logOf(app).log.any((e) => e.name == Events.sevenDayProgress), isTrue);

    // -- stage 2: free through level 5, wall at 6 ---------------------------
    for (var lvl = 1; lvl <= stage2FreeLevels; lvl++) {
      final d = app.gate.canPlayLevel(
          app.entitlements, StageId.blockBuilder, lvl);
      expect(d.allowed, isTrue, reason: 'level $lvl must be free');
      final round = BlockBuilderRound(
          level: stage2Levels[lvl - 1],
          tracker: tracker,
          random: Random(lvl));
      final touched = <String>{};
      while (!round.finished) {
        final p = round.current!;
        touched.add(p.target.choseongJamo.id);
        p.place(p.target.choseongJamo, SlotKind.choseong);
        p.place(p.target.jungseongJamo, SlotKind.jungseong);
        if (p.needsJongseong) {
          p.place(p.target.jongseongJamo!, SlotKind.jongseong);
        }
        round.completeCurrent();
      }
      app.onStageComplete(
        stage: StageId.blockBuilder,
        level: lvl,
        stars: round.score.stars,
        points: round.score.points,
        mistakes: round.score.wrong,
        touchedJamoIds: touched.toList(),
      );
    }
    final wall = app.gate.canPlayLevel(
        app.entitlements, StageId.blockBuilder, stage2FreeLevels + 1);
    expect(wall.allowed, isFalse);
    final trigger = app.gate.paywallTriggerFor(wall.reason)!;
    app.logPaywallShown(trigger);
    expect(
        logOf(app)
            .log
            .where((e) => e.name == Events.paywallShown)
            .single
            .params['trigger'],
        'stage2_lock');

    // -- purchase through the mock gateway ----------------------------------
    final products = await app.services.billing.fetchProducts();
    final result = await app
        .purchase(products.firstWhere((p) => p.plan == SubscriptionPlan.yearly));
    expect(result.success, isTrue);
    expect(app.isPremium, isTrue);
    expect(logOf(app).log.any((e) => e.name == Events.trialStart), isTrue);

    // wall opens without any other change
    expect(
        app.gate
            .canPlayLevel(
                app.entitlements, StageId.blockBuilder, stage2FreeLevels + 1)
            .allowed,
        isTrue);
    expect(
        app.gate.canPlayLevel(app.entitlements, StageId.wordRush, 1).allowed,
        isTrue);

    // -- audio slots exercised ----------------------------------------------
    final audio = app.services.audio as DevAudioManager;
    await app.playSyllable(allStage2Targets().first);
    expect(audio.playedLog.last, startsWith('voice/syllable/'));
  });

  test('review teaser: one free session/day, then paywall trigger', () async {
    final app = buildApp();
    await app.init();

    expect(app.startReviewSession(), isTrue, reason: 'first teaser allowed');
    expect(app.startReviewSession(), isFalse, reason: 'quota exhausted');
    final d = app.gate.canStartReview(app.entitlements);
    expect(app.gate.paywallTriggerFor(d.reason), 'review_teaser_end');
    expect(
        logOf(app).log.any((e) => e.name == Events.reviewTeaserUsed), isTrue);
  });

  test('speech unavailable disables stage 4 without a paywall', () async {
    final app = buildApp(speech: UnsupportedSpeechRecognizer());
    await app.init();
    final d = app.gate
        .canPlayLevel(app.entitlements, StageId.pronunciation, 1);
    expect(d.allowed, isFalse);
    expect(d.reason, LockReason.speechUnavailable);
    expect(app.gate.paywallTriggerFor(d.reason), isNull);
  });

  test('pronunciation flow end-to-end with fake recognizer', () async {
    final app =
        buildApp(speech: FakeSpeechRecognizer(scriptedTranscript: '안녕'));
    await app.init();
    final result = await app.services.speech.listen();
    final score = app.services.scorer.score('안녕', result!);
    expect(score.score, greaterThan(60));
  });

  test('store build guard: dev gateway cannot ship in appStore channel', () {
    expect(
      () => AppServices(
        billing: MockBillingGateway(),
        speech: UnsupportedSpeechRecognizer(),
        scorer: const JamoSimilarityScorer(),
        audio: DevAudioManager(),
        haptics: NoopHaptics(),
        push: NoopPush(),
        analytics: LocalAnalytics(),
        channel: BuildChannel.appStore,
      ),
      throwsAssertionError,
    );
  });
}
