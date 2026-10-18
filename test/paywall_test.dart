import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/core/data/curriculum.dart';
import 'package:hangul_quest/core/economy/content_gate.dart';

void main() {
  const gate = ContentGate();
  const free = EntitlementState();
  const premium = EntitlementState(isPremium: true);

  group('free/premium boundary (spec §5.1)', () {
    test('stage 1 fully free', () {
      for (var lvl = 1; lvl <= stage1Levels.length; lvl++) {
        expect(gate.canPlayLevel(free, StageId.jamoHunt, lvl).allowed, isTrue);
      }
    });

    test('stage 2: levels 1-5 free, 6+ locked for free users', () {
      for (var lvl = 1; lvl <= stage2FreeLevels; lvl++) {
        expect(
            gate.canPlayLevel(free, StageId.blockBuilder, lvl).allowed, isTrue);
      }
      for (var lvl = stage2FreeLevels + 1; lvl <= stage2Levels.length; lvl++) {
        final d = gate.canPlayLevel(free, StageId.blockBuilder, lvl);
        expect(d.allowed, isFalse);
        expect(d.reason, LockReason.stage2LatterHalf);
      }
    });

    test('stage 2 fully open for premium', () {
      for (var lvl = 1; lvl <= stage2Levels.length; lvl++) {
        expect(gate.canPlayLevel(premium, StageId.blockBuilder, lvl).allowed,
            isTrue);
      }
    });

    test('stage 3 premium-only', () {
      expect(gate.canPlayLevel(free, StageId.wordRush, 1).allowed, isFalse);
      expect(gate.canPlayLevel(free, StageId.wordRush, 1).reason,
          LockReason.wordRushPremium);
      expect(gate.canPlayLevel(premium, StageId.wordRush, 1).allowed, isTrue);
    });

    test('stage 4 premium-only when speech available', () {
      final d = gate.canPlayLevel(free, StageId.pronunciation, 1);
      expect(d.allowed, isFalse);
      expect(d.reason, LockReason.pronunciationPremium);
      expect(gate.canPlayLevel(premium, StageId.pronunciation, 1).allowed,
          isTrue);
    });

    test('stage 4 speech unavailable: locked even for premium, NO paywall',
        () {
      const noSpeech = EntitlementState(
          isPremium: true, speechAvailable: false);
      final d = gate.canPlayLevel(noSpeech, StageId.pronunciation, 1);
      expect(d.allowed, isFalse);
      expect(d.reason, LockReason.speechUnavailable);
      expect(gate.paywallTriggerFor(d.reason), isNull,
          reason: 'never sell a feature the device cannot run');
    });

    test('codex and mini-lessons are always free', () {
      expect(gate.canOpenCodex(free).allowed, isTrue);
      expect(gate.canOpenMiniLesson(free).allowed, isTrue);
    });
  });

  group('smart review teaser', () {
    test('free user gets exactly one teaser per day', () {
      expect(gate.canStartReview(free).allowed, isTrue);
      const used = EntitlementState(reviewTeasersUsedToday: 1);
      final d = gate.canStartReview(used);
      expect(d.allowed, isFalse);
      expect(d.reason, LockReason.reviewQuotaExhausted);
    });

    test('premium review is unlimited', () {
      const p = EntitlementState(isPremium: true, reviewTeasersUsedToday: 99);
      expect(gate.canStartReview(p).allowed, isTrue);
    });
  });

  group('paywall triggers (spec §5.3)', () {
    test('each lock maps to its analytics trigger', () {
      expect(gate.paywallTriggerFor(LockReason.stage2LatterHalf),
          'stage2_lock');
      expect(gate.paywallTriggerFor(LockReason.pronunciationPremium),
          'pronunciation_entry');
      expect(gate.paywallTriggerFor(LockReason.reviewQuotaExhausted),
          'review_teaser_end');
      expect(gate.paywallTriggerFor(LockReason.none), isNull);
    });

    test('streak repair is premium-gated', () {
      expect(gate.canRepairStreak(free), isFalse);
      expect(gate.canRepairStreak(premium), isTrue);
    });
  });
}
