import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/core/adaptive/error_tracker.dart';
import 'package:hangul_quest/core/data/curriculum.dart';
import 'package:hangul_quest/core/game/round_engine.dart';
import 'package:hangul_quest/core/hangul/hangul.dart';

void main() {
  group('AssemblyPuzzle (stage 2 core)', () {
    late ErrorTracker tracker;

    setUp(() => tracker = ErrorTracker(random: Random(1)));

    AssemblyPuzzle puzzleFor(String ch) => AssemblyPuzzle(
        target: decompose(ch.runes.first),
        tracker: tracker,
        random: Random(2));

    test('가: choseong then jungseong completes, no batchim slot', () {
      final p = puzzleFor('가');
      expect(p.needsJongseong, isFalse);
      expect(p.layout, SyllableLayout.vertical);

      expect(p.place(choseongTable[0], SlotKind.choseong),
          PlacementResult.accepted);
      expect(p.place(jungseongTable[0], SlotKind.jungseong),
          PlacementResult.completed);
      expect(p.assembled!.char, '가');
      expect(p.mistakes, 0);
    });

    test('강: all three slots required, completion emits the syllable', () {
      final p = puzzleFor('강');
      expect(p.needsJongseong, isTrue);
      p.place(p.target.choseongJamo, SlotKind.choseong);
      p.place(p.target.jungseongJamo, SlotKind.jungseong);
      expect(p.completed, isFalse);
      expect(p.place(p.target.jongseongJamo!, SlotKind.jongseong),
          PlacementResult.completed);
      expect(p.assembled!.char, '강');
    });

    test('vowel into consonant slot is rejected with a teaching hint', () {
      final p = puzzleFor('가');
      final vowel = jungseongTable[0];
      expect(p.place(vowel, SlotKind.choseong), PlacementResult.rejectedRole);
      expect(p.hintFor(vowel, SlotKind.choseong), contains('Vowels'));
      expect(p.mistakes, 1);
    });

    test('right role, wrong jamo: rejected and tracked against target sound',
        () {
      final p = puzzleFor('가');
      final wrong = choseongTable[2]; // ㄴ where ㄱ is wanted
      expect(
          p.place(wrong, SlotKind.choseong), PlacementResult.rejectedWrong);
      expect(tracker.statsFor('c_giyeok').wrong, 1);
    });

    test('tray contains target parts plus distractors', () {
      final p = puzzleFor('강');
      final chars = p.tray.map((j) => j.char).toList();
      expect(chars, contains('ㄱ'));
      expect(chars, contains('ㅏ'));
      expect(chars, contains('ㅇ'));
      expect(p.tray.length, 7); // 3 target + 2 consonant + 2 vowel decoys
    });

    test('layout drives slot morphing across the curriculum', () {
      expect(puzzleFor('고').layout, SyllableLayout.horizontal);
      expect(puzzleFor('과').layout, SyllableLayout.mixed);
    });
  });

  group('BlockBuilderRound', () {
    test('full playthrough of level 1 completes with perfect score', () {
      final tracker = ErrorTracker(random: Random(3));
      final round = BlockBuilderRound(
          level: stage2Levels[0], tracker: tracker, random: Random(4));

      while (!round.finished) {
        final p = round.current!;
        p.place(p.target.choseongJamo, SlotKind.choseong);
        p.place(p.target.jungseongJamo, SlotKind.jungseong);
        if (p.needsJongseong) {
          p.place(p.target.jongseongJamo!, SlotKind.jongseong);
        }
        expect(p.completed, isTrue);
        round.completeCurrent();
      }
      expect(round.completedCount, round.totalCount);
      expect(round.score.correct, stage2Levels[0].syllableTargets.length);
      expect(round.score.wrong, 0);
      expect(round.score.stars, 3);
    });
  });

  group('JamoHuntRound', () {
    test('generates the requested question count with valid choices', () {
      final tracker = ErrorTracker(random: Random(5));
      final round = JamoHuntRound(
          level: stage1Levels[0], tracker: tracker, random: Random(6));
      expect(round.questions.length, 10);
      for (final q in round.questions) {
        expect(q.choices.map((c) => c.id), contains(q.answer.id));
        expect(q.choices.toSet().length, q.choices.length);
      }
    });

    test('combo multiplier ramps at 3 and 6 consecutive correct answers', () {
      final tracker = ErrorTracker(random: Random(7));
      final round = JamoHuntRound(
          level: stage1Levels[0], tracker: tracker, random: Random(8));
      for (var i = 0; i < 7; i++) {
        final q = round.current!;
        round.answer(q.answer, tracker: tracker);
      }
      expect(round.score.combo, 7);
      expect(round.score.multiplier, 3);
      expect(round.score.maxCombo, 7);
    });

    test('wrong answer breaks combo and records the miss', () {
      final tracker = ErrorTracker(random: Random(9));
      final round = JamoHuntRound(
          level: stage1Levels[0], tracker: tracker, random: Random(10));
      final q = round.current!;
      final wrong = q.choices.firstWhere((c) => c.id != q.answer.id);
      expect(round.answer(wrong, tracker: tracker), isFalse);
      expect(round.score.combo, 0);
      expect(tracker.statsFor(q.answer.id).wrong, 1);
    });
  });

  group('adaptive weighting', () {
    test('missed jamo get boosted weight; 5-streak decays it', () {
      final t = ErrorTracker(random: Random(11));
      t.recordWrong('c_giyeok');
      t.recordWrong('c_giyeok');
      t.recordCorrect('c_nieun');
      expect(t.weightFor('c_giyeok'), greaterThan(t.weightFor('c_nieun')));

      for (var i = 0; i < 5; i++) {
        t.recordCorrect('c_giyeok');
      }
      final decayed = t.weightFor('c_giyeok');
      expect(decayed, lessThan(1.0 + (2 / 7) * ErrorTracker.errorWeightFactor));
      expect(decayed, greaterThanOrEqualTo(1.0));
    });

    test('weighted sampling favors weak items over many draws', () {
      final t = ErrorTracker(random: Random(12));
      for (var i = 0; i < 8; i++) {
        t.recordWrong('weak');
        t.recordCorrect('strong');
      }
      var weakFirst = 0;
      for (var i = 0; i < 300; i++) {
        final picked = t.sample(['weak', 'strong'], 1);
        if (picked.single == 'weak') weakFirst++;
      }
      expect(weakFirst, greaterThan(180),
          reason: 'weak item (weight 4.0 vs 1.0) should win ~80% of draws');
    });
  });

  group('stage 2 curriculum data', () {
    test('every syllable target decomposes to blocks its level teaches', () {
      for (final s in allStage2Targets()) {
        expect(isSyllable(s.codePoint), isTrue);
      }
    });
  });
}
