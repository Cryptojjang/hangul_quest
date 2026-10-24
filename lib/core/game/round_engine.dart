/// Pure round logic for stages 1–3. UI layers render these engines; tests
/// drive them headlessly. No Flutter imports.
library;

import 'dart:math';

import '../adaptive/error_tracker.dart';
import '../data/curriculum.dart';
import '../data/vocab.dart';
import '../hangul/hangul.dart';

class RoundScore {
  int correct = 0;
  int wrong = 0;
  int combo = 0;
  int maxCombo = 0;
  int points = 0;

  /// Combo multiplier kicks in from 3 consecutive correct answers.
  int get multiplier => combo >= 6 ? 3 : (combo >= 3 ? 2 : 1);

  void addCorrect({int base = 10, int timeBonus = 0}) {
    correct += 1;
    combo += 1;
    maxCombo = max(maxCombo, combo);
    points += (base + timeBonus) * multiplier;
  }

  void addWrong() {
    wrong += 1;
    combo = 0;
  }

  /// 1–3 stars from accuracy.
  int get stars {
    final total = correct + wrong;
    if (total == 0) return 0;
    final acc = correct / total;
    if (acc >= 0.95) return 3;
    if (acc >= 0.8) return 2;
    return 1;
  }
}

// ---------------------------------------------------------------------------
// Stage 1 — Jamo Hunt
// ---------------------------------------------------------------------------

class JamoHuntQuestion {
  const JamoHuntQuestion({required this.answer, required this.choices});

  final Jamo answer;
  final List<Jamo> choices; // includes answer, shuffled
}

class JamoHuntRound {
  JamoHuntRound({
    required StageLevel level,
    required ErrorTracker tracker,
    int questionCount = 10,
    int choicesPerQuestion = 6,
    Random? random,
  }) : _random = random ?? Random() {
    // Pool = this level's jamo + earlier-introduced jamo for review breadth.
    final levelIdx = stage1Levels.indexOf(level);
    final pool = <String>{
      ...level.jamoIds,
      for (var i = 0; i <= levelIdx && i >= 0; i++) ...stage1Levels[i].jamoIds,
    }.toList();

    // Adaptive: frequently-missed jamo are sampled more often as answers.
    final answers = <String>[];
    while (answers.length < questionCount) {
      final picked = tracker.sample(pool, min(pool.length, questionCount - answers.length));
      answers.addAll(picked);
    }

    for (final answerId in answers.take(questionCount)) {
      final answer = jamoById[answerId]!;
      final distractors = pool.where((id) => id != answerId).toList()
        ..shuffle(_random);
      final choices = <Jamo>[
        answer,
        ...distractors
            .take(choicesPerQuestion - 1)
            .map((id) => jamoById[id]!),
      ]..shuffle(_random);
      questions.add(JamoHuntQuestion(answer: answer, choices: choices));
    }
  }

  final Random _random;
  final List<JamoHuntQuestion> questions = [];
  final RoundScore score = RoundScore();
  int _cursor = 0;

  JamoHuntQuestion? get current =>
      _cursor < questions.length ? questions[_cursor] : null;
  bool get finished => _cursor >= questions.length;

  /// Per-question time limit (seconds), spec §3.1.
  static const questionSeconds = 5;

  /// Answer the current question. Returns true when correct.
  bool answer(Jamo tapped, {double secondsLeft = 0, required ErrorTracker tracker}) {
    final q = current;
    if (q == null) return false;
    final ok = tapped.id == q.answer.id;
    if (ok) {
      tracker.recordCorrect(q.answer.id);
      score.addCorrect(timeBonus: (secondsLeft * 2).round());
    } else {
      tracker.recordWrong(q.answer.id);
      score.addWrong();
    }
    _cursor += 1;
    return ok;
  }

  /// Time-out counts as a miss on the target jamo.
  void timeout({required ErrorTracker tracker}) {
    final q = current;
    if (q == null) return;
    tracker.recordWrong(q.answer.id);
    score.addWrong();
    _cursor += 1;
  }
}

// ---------------------------------------------------------------------------
// Stage 2 — Block Builder (the core differentiator)
// ---------------------------------------------------------------------------

enum SlotKind { choseong, jungseong, jongseong }

enum PlacementResult { accepted, completed, rejectedRole, rejectedWrong }

class AssemblyPuzzle {
  AssemblyPuzzle({required this.target, required ErrorTracker tracker, Random? random})
      : _tracker = tracker,
        _random = random ?? Random() {
    _buildTray();
  }

  final Syllable target;
  final ErrorTracker _tracker;
  final Random _random;

  /// Blocks offered in the tray (target parts + distractors), shuffled.
  final List<Jamo> tray = [];

  Jamo? placedChoseong;
  Jamo? placedJungseong;
  Jamo? placedJongseong;
  int mistakes = 0;

  SyllableLayout get layout => target.layout;
  bool get needsJongseong => target.hasBatchim;

  bool get completed =>
      placedChoseong != null &&
      placedJungseong != null &&
      (!needsJongseong || placedJongseong != null);

  /// The syllable currently assembled (null until complete).
  Syllable? get assembled {
    if (!completed) return null;
    return Syllable(
      choseong: placedChoseong!.index,
      jungseong: placedJungseong!.index,
      jongseong: needsJongseong ? placedJongseong!.index : 0,
    );
  }

  void _buildTray() {
    tray.add(target.choseongJamo);
    tray.add(target.jungseongJamo);
    if (needsJongseong) tray.add(target.jongseongJamo!);

    // Distractors: 2 consonants + 2 vowels not in the target.
    final cPool = choseongTable
        .where((j) => j.index != target.choseong)
        .toList()
      ..shuffle(_random);
    final vPool = jungseongTable
        .where((j) => j.index != target.jungseong)
        .toList()
      ..shuffle(_random);
    tray.addAll(cPool.take(2));
    tray.addAll(vPool.take(2));
    tray.shuffle(_random);
  }

  /// Attempts to drop [block] into [slot].
  ///
  /// Role mismatches (vowel into a consonant slot, etc.) are rejected with a
  /// teaching hint; right-role-wrong-jamo is also rejected and tracked as a
  /// mistake against the TARGET jamo (that's the sound being confused).
  PlacementResult place(Jamo block, SlotKind slot) {
    final Jamo wanted;
    final bool roleOk;
    switch (slot) {
      case SlotKind.choseong:
        wanted = target.choseongJamo;
        roleOk = block.role == JamoRole.choseong;
      case SlotKind.jungseong:
        wanted = target.jungseongJamo;
        roleOk = block.role == JamoRole.jungseong;
      case SlotKind.jongseong:
        if (!needsJongseong) return PlacementResult.rejectedRole;
        wanted = target.jongseongJamo!;
        // Tray batchim blocks come from jongseongTable, but a same-shaped
        // choseong block is also a legal batchim drop for most consonants.
        roleOk = block.role != JamoRole.jungseong;
    }

    if (!roleOk) {
      mistakes += 1;
      return PlacementResult.rejectedRole;
    }
    if (block.char != wanted.char) {
      mistakes += 1;
      _tracker.recordWrong(wanted.id);
      return PlacementResult.rejectedWrong;
    }

    switch (slot) {
      case SlotKind.choseong:
        placedChoseong = wanted;
      case SlotKind.jungseong:
        placedJungseong = wanted;
      case SlotKind.jongseong:
        placedJongseong = wanted;
    }
    _tracker.recordCorrect(wanted.id);
    return completed ? PlacementResult.completed : PlacementResult.accepted;
  }

  /// Teaching hint for a rejected placement (design spec: reject + 1-line why).
  String hintFor(Jamo block, SlotKind slot) {
    if (block.role == JamoRole.jungseong && slot != SlotKind.jungseong) {
      return 'Vowels only go in the middle slot';
    }
    if (block.role != JamoRole.jungseong && slot == SlotKind.jungseong) {
      return 'Consonants cannot go in the middle slot';
    }
    return block.hint ?? 'Not this sound. Listen again';
  }
}

class BlockBuilderRound {
  BlockBuilderRound({
    required this.level,
    required ErrorTracker tracker,
    Random? random,
  })  : _tracker = tracker,
        _random = random ?? Random() {
    _targets = level.syllableTargets
        .map((t) => decompose(t.runes.first))
        .toList();
    _advance();
  }

  final StageLevel level;
  final ErrorTracker _tracker;
  final Random _random;
  final RoundScore score = RoundScore();

  late List<Syllable> _targets;
  int _cursor = -1;
  AssemblyPuzzle? current;

  bool get finished => current == null && _cursor >= _targets.length;

  /// Puzzles already completed in this round.
  int get completedCount => _cursor.clamp(0, _targets.length);

  int get totalCount => _targets.length;

  void _advance() {
    _cursor += 1;
    current = _cursor < _targets.length
        ? AssemblyPuzzle(
            target: _targets[_cursor], tracker: _tracker, random: _random)
        : null;
  }

  /// Called by UI when the current puzzle reports [PlacementResult.completed].
  void completeCurrent() {
    final p = current;
    if (p == null || !p.completed) return;
    if (p.mistakes == 0) {
      score.addCorrect(base: 20);
    } else {
      score.addCorrect(base: 10);
      score.combo = 0; // imperfect assembly breaks combo
    }
    _advance();
  }
}

// ---------------------------------------------------------------------------
// Stage 3 — Word Rush
// ---------------------------------------------------------------------------

class WordRushQuestion {
  const WordRushQuestion({required this.answer, required this.options});

  final VocabWord answer;
  final List<VocabWord> options; // 4, includes answer
}

class WordRushRound {
  WordRushRound({required StageLevel level, Random? random})
      : _random = random ?? Random() {
    final words = level.wordIds.map((id) => vocabById[id]!).toList()
      ..shuffle(_random);
    for (final w in words) {
      final distractors = vocabWords
          .where((o) => o.id != w.id)
          .toList()
        ..shuffle(_random);
      final options = <VocabWord>[w, ...distractors.take(3)]
        ..shuffle(_random);
      questions.add(WordRushQuestion(answer: w, options: options));
    }
  }

  final Random _random;
  final List<WordRushQuestion> questions = [];
  final RoundScore score = RoundScore();
  int _cursor = 0;

  static const questionSeconds = 6;

  WordRushQuestion? get current =>
      _cursor < questions.length ? questions[_cursor] : null;
  bool get finished => _cursor >= questions.length;

  bool answer(VocabWord picked,
      {double secondsLeft = 0, required ErrorTracker tracker}) {
    final q = current;
    if (q == null) return false;
    final ok = picked.id == q.answer.id;
    if (ok) {
      score.addCorrect(timeBonus: (secondsLeft * 3).round());
      for (final id in jamoIdsInWord(q.answer.korean)) {
        tracker.recordCorrect(id);
      }
    } else {
      score.addWrong();
      // A misread word marks every jamo it contains for review weighting.
      for (final id in jamoIdsInWord(q.answer.korean)) {
        tracker.recordWrong(id);
      }
    }
    _cursor += 1;
    return ok;
  }
}
