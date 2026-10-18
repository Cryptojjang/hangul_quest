/// Emits the TTS synthesis job list (slot id → spoken text → wav path) as
/// JSON, derived from the real jamo/curriculum/vocab tables so audio slots
/// can never drift from game data. Runnable with plain `dart` (no pub get).
///
///   dart run tool/gen_tts_jobs.dart > tool/tts_jobs.json
// ignore_for_file: avoid_relative_lib_imports, avoid_print
library;

import 'dart:convert';

import '../lib/core/data/curriculum.dart';
import '../lib/core/data/vocab.dart';
import '../lib/core/hangul/hangul.dart';

/// A consonant is introduced by name + a carrier syllable (기역, 가);
/// a vowel by its sound (아); a batchim by name + example (기역 받침, 강).
String spokenTextFor(Jamo j) => switch (j.role) {
      JamoRole.choseong => '${j.nameKo}, ${compose(j.index, 0).char}',
      JamoRole.jungseong => compose(11, j.index).char, // ㅇ + vowel
      JamoRole.jongseong => j.nameKo,
    };

void main() {
  final jobs = <Map<String, String>>[];
  void add(String slot, String text) => jobs.add({
        'slot': slot,
        'text': text,
        'file': 'assets/audio/$slot.wav',
      });

  for (final j in jamoById.values) {
    add('voice/jamo/${j.id}', spokenTextFor(j));
  }

  for (final cp in <int>{for (final s in allStage2Targets()) s.codePoint}) {
    add('voice/syllable/$cp', String.fromCharCode(cp));
  }

  for (final w in vocabWords) {
    add('voice/word/${w.id}', w.korean);
  }

  add('voice/ui/great', '잘했어요!');
  add('voice/ui/perfect', '완벽해요!');
  add('voice/ui/almost', '아깝다!');
  add('voice/ui/combo', '대단해요!');

  print(const JsonEncoder.withIndent('  ').convert(jobs));
}
