/// Free/premium boundary + paywall trigger logic (spec §5.1, §5.3).
///
/// Single source of truth for what is locked. UI never hardcodes locks; it
/// asks this gate. Pure Dart, fully unit-tested in test/paywall_test.dart.
library;

import '../data/curriculum.dart';

/// Stage-2 levels 1..[stage2FreeLevels] are free; later levels are premium.
const int stage2FreeLevels = 5;

/// Free smart-review teasers per day.
const int reviewTeasersPerDay = 1;

enum LockReason {
  none,
  stage2LatterHalf,
  wordRushPremium,
  pronunciationPremium,
  reviewQuotaExhausted,
  speechUnavailable,
}

class GateDecision {
  const GateDecision(this.allowed, this.reason);

  final bool allowed;
  final LockReason reason;

  static const open = GateDecision(true, LockReason.none);
}

/// Entitlement snapshot the gate evaluates against. Kept deliberately dumb —
/// billing layer produces it, progress store persists the review counter.
class EntitlementState {
  const EntitlementState({
    this.isPremium = false,
    this.reviewTeasersUsedToday = 0,
    this.speechAvailable = true,
  });

  final bool isPremium;
  final int reviewTeasersUsedToday;

  /// False on platforms where speech recognition degraded away (web).
  final bool speechAvailable;

  EntitlementState copyWith({
    bool? isPremium,
    int? reviewTeasersUsedToday,
    bool? speechAvailable,
  }) =>
      EntitlementState(
        isPremium: isPremium ?? this.isPremium,
        reviewTeasersUsedToday:
            reviewTeasersUsedToday ?? this.reviewTeasersUsedToday,
        speechAvailable: speechAvailable ?? this.speechAvailable,
      );
}

class ContentGate {
  const ContentGate();

  /// Can the player enter [stage] level [level] (1-based)?
  GateDecision canPlayLevel(EntitlementState e, StageId stage, int level) {
    switch (stage) {
      case StageId.jamoHunt:
        return GateDecision.open; // stage 1 fully free
      case StageId.blockBuilder:
        if (e.isPremium || level <= stage2FreeLevels) {
          return GateDecision.open;
        }
        return const GateDecision(false, LockReason.stage2LatterHalf);
      case StageId.wordRush:
        return e.isPremium
            ? GateDecision.open
            : const GateDecision(false, LockReason.wordRushPremium);
      case StageId.pronunciation:
        if (!e.speechAvailable) {
          // Graceful degradation beats a paywall: never sell a broken mode.
          return const GateDecision(false, LockReason.speechUnavailable);
        }
        return e.isPremium
            ? GateDecision.open
            : const GateDecision(false, LockReason.pronunciationPremium);
    }
  }

  /// Codex and mini-lessons are always free (spec §4).
  GateDecision canOpenCodex(EntitlementState e) => GateDecision.open;
  GateDecision canOpenMiniLesson(EntitlementState e) => GateDecision.open;

  /// Smart review: unlimited for premium; free tier gets a daily teaser.
  GateDecision canStartReview(EntitlementState e) {
    if (e.isPremium) return GateDecision.open;
    if (e.reviewTeasersUsedToday < reviewTeasersPerDay) {
      return GateDecision.open;
    }
    return const GateDecision(false, LockReason.reviewQuotaExhausted);
  }

  /// Streak repair is a premium perk (spec §5.1) — free users get the offer
  /// as a paywall trigger instead.
  bool canRepairStreak(EntitlementState e) => e.isPremium;

  /// Maps a lock to the paywall trigger id logged in analytics. Returns null
  /// when a paywall is NOT the right response (e.g. speech unavailable).
  String? paywallTriggerFor(LockReason reason) => switch (reason) {
        LockReason.stage2LatterHalf => 'stage2_lock',
        LockReason.wordRushPremium => 'stage2_lock',
        LockReason.pronunciationPremium => 'pronunciation_entry',
        LockReason.reviewQuotaExhausted => 'review_teaser_end',
        LockReason.speechUnavailable => null,
        LockReason.none => null,
      };
}
