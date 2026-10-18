import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/platform/speech/pronunciation_scorer.dart';
import 'package:hangul_quest/platform/speech/speech.dart';
import 'package:hangul_quest/state/progress_store.dart';

void main() {
  group('ProgressState streak', () {
    test('same-day plays count once; consecutive days grow the streak', () {
      var now = DateTime(2026, 7, 17, 20);
      final s = ProgressState(clock: () => now);
      expect(s.touchStreak(), isTrue);
      expect(s.streakDays, 1);
      expect(s.touchStreak(), isFalse); // same day
      now = DateTime(2026, 7, 18, 8);
      expect(s.touchStreak(), isTrue);
      expect(s.streakDays, 2);
    });

    test('missing a day resets; exactly one missed day is repairable', () {
      var now = DateTime(2026, 7, 17);
      final s = ProgressState(clock: () => now);
      s.touchStreak();
      now = DateTime(2026, 7, 19); // skipped the 18th
      expect(s.streakRepairable, isTrue);
      s.repairStreak();
      expect(s.streakDays, 2);

      now = DateTime(2026, 7, 25); // long gap: not repairable, resets
      expect(s.streakRepairable, isFalse);
      s.touchStreak();
      expect(s.streakDays, 1);
    });
  });

  group('review teaser counter', () {
    test('resets across days', () {
      var now = DateTime(2026, 7, 17);
      final s = ProgressState(clock: () => now);
      expect(s.teasersUsedToday(), 0);
      s.useTeaser();
      expect(s.teasersUsedToday(), 1);
      now = DateTime(2026, 7, 18);
      expect(s.teasersUsedToday(), 0);
      s.useTeaser();
      expect(s.teasersUsedToday(), 1);
    });
  });

  group('codex', () {
    test('unlock once, then master', () {
      final s = ProgressState(clock: DateTime.now);
      expect(s.unlockCodex('c_giyeok'), isTrue);
      expect(s.unlockCodex('c_giyeok'), isFalse);
      expect(s.codex['c_giyeok'], 1);
      expect(s.masterCodex('c_giyeok'), isTrue);
      expect(s.masterCodex('c_giyeok'), isFalse);
      expect(s.codex['c_giyeok'], 2);
    });
  });

  group('persistence roundtrip', () {
    test('full state tree survives save/load', () async {
      var now = DateTime(2026, 7, 17);
      final storage = InMemoryStorage();
      final store = ProgressStore(storage, clock: () => now);
      final s = store.state;
      s.onboardingDone = true;
      s.markCleared('jamoHunt', 3);
      s.unlockCodex('v_a');
      s.xp = 420;
      s.touchStreak();
      s.useTeaser();
      s.errors.recordWrong('c_giyeok');
      await store.save();

      final restored = ProgressStore(storage, clock: () => now);
      await restored.load();
      final r = restored.state;
      expect(r.onboardingDone, isTrue);
      expect(r.cleared('jamoHunt'), 3);
      expect(r.codex['v_a'], 1);
      expect(r.xp, 420);
      expect(r.streakDays, 1);
      expect(r.teasersUsedToday(), 1);
      expect(r.errors.statsFor('c_giyeok').wrong, 1);
      expect(r.updatedAt, now);
    });

    test('corrupt storage falls back to fresh state', () async {
      final storage = InMemoryStorage();
      await storage.write('{not json!!');
      final store = ProgressStore(storage);
      await store.load();
      expect(store.state.xp, 0);
    });
  });

  group('JamoSimilarityScorer', () {
    const scorer = JamoSimilarityScorer();

    test('perfect match scores 100 at full confidence', () {
      final r = scorer.score('안녕',
          const RecognitionResult(transcript: '안녕', confidence: 1.0));
      expect(r.score, 100);
      expect(r.perJamoFeedback.values.every((ok) => ok), isTrue);
    });

    test('confusable pair earns partial credit', () {
      // 바 vs 파: ㅂ/ㅍ are confusable — should beat a totally wrong answer.
      final confusable = scorer.score('바',
          const RecognitionResult(transcript: '파', confidence: 1.0));
      final unrelated = scorer.score('바',
          const RecognitionResult(transcript: '소', confidence: 1.0));
      expect(confusable.score, greaterThan(unrelated.score));
      expect(confusable.score, lessThan(100));
    });

    test('empty transcript scores near zero', () {
      final r = scorer.score('안녕',
          const RecognitionResult(transcript: '', confidence: 1.0));
      expect(r.score, lessThan(20));
    });

    test('low recognizer confidence caps the score', () {
      final high = scorer.score('가',
          const RecognitionResult(transcript: '가', confidence: 1.0));
      final low = scorer.score('가',
          const RecognitionResult(transcript: '가', confidence: 0.1));
      expect(low.score, lessThan(high.score));
    });

    test('per-jamo feedback marks the mismatched sound', () {
      final r = scorer.score('강',
          const RecognitionResult(transcript: '간', confidence: 1.0));
      expect(r.perJamoFeedback['c_giyeok'], isTrue);
      expect(r.perJamoFeedback['v_a'], isTrue);
      expect(r.perJamoFeedback['f_ieung'], isFalse);
    });
  });
}
