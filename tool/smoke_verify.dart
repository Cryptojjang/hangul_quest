/// Standalone smoke verification runnable with plain `dart` (no pub get):
/// exercises composition, SRS, gate, adaptive, scorer via relative imports.
/// CI/full coverage lives in test/ (flutter test).
// ignore_for_file: avoid_relative_lib_imports, avoid_print
library;

import '../lib/core/adaptive/error_tracker.dart';
import '../lib/core/data/curriculum.dart';
import '../lib/core/economy/content_gate.dart';
import '../lib/core/hangul/hangul.dart';
import '../lib/core/srs/srs.dart';

void check(bool cond, String label) {
  if (!cond) {
    throw StateError('FAIL: $label');
  }
  print('  ok: $label');
}

void main() {
  print('[1] hangul composition');
  check(compose(0, 0).char == '가', 'ㄱ+ㅏ=가');
  check(compose(0, 0, 21).char == '강', 'ㄱ+ㅏ+ㅇ=강');
  check(compose(18, 20, 27).char == '힣', 'last syllable 힣');
  var n = 0;
  for (var c = 0; c < 19; c++) {
    for (var v = 0; v < 21; v++) {
      for (var f = 0; f < 28; f++) {
        final s = compose(c, v, f);
        final b = decompose(s.codePoint);
        if (b.choseong != c || b.jungseong != v || b.jongseong != f) {
          throw StateError('roundtrip fail at $c/$v/$f');
        }
        n++;
      }
    }
  }
  check(n == 11172, 'roundtrip all 11,172 syllables');
  check(decompose('과'.runes.first).layout == SyllableLayout.mixed, '과 layout=mixed');
  check(decompose('고'.runes.first).layout == SyllableLayout.horizontal, '고 layout=horizontal');
  check(jamoIdsInWord('김치').join(',') == 'c_giyeok,v_i,f_mieum,c_chieut,v_i', '김치 jamo ids');

  print('[2] SRS');
  var now = DateTime(2026, 7, 17);
  final srs = SrsScheduler(clock: () => now);
  check(srs.review('a', ReviewGrade.good) == 1, 'first interval 1d');
  check(srs.review('a', ReviewGrade.good) == 3, 'second interval 3d');
  check(srs.review('a', ReviewGrade.good) > 3, 'third interval grows');
  srs.review('a', ReviewGrade.again);
  check(srs.cardFor('a').repetitions == 0 && srs.cardFor('a').lapses == 1, 'lapse resets');
  now = now.add(const Duration(minutes: 11));
  check(srs.dueCards().length == 1, 'relearn due in 10min');
  final restored = SrsScheduler(clock: () => now)..loadJson(srs.toJson());
  check(restored.cardFor('a').lapses == 1, 'serialization roundtrip');

  print('[3] content gate');
  const gate = ContentGate();
  const free = EntitlementState();
  const prem = EntitlementState(isPremium: true);
  check(gate.canPlayLevel(free, StageId.jamoHunt, 7).allowed, 'stage1 free');
  check(gate.canPlayLevel(free, StageId.blockBuilder, 5).allowed, 'stage2 L5 free');
  check(!gate.canPlayLevel(free, StageId.blockBuilder, 6).allowed, 'stage2 L6 locked');
  check(gate.canPlayLevel(prem, StageId.blockBuilder, 9).allowed, 'stage2 L9 premium');
  check(!gate.canPlayLevel(free, StageId.wordRush, 1).allowed, 'stage3 locked');
  check(gate.paywallTriggerFor(LockReason.reviewQuotaExhausted) == 'review_teaser_end', 'trigger map');
  const noSpeech = EntitlementState(isPremium: true, speechAvailable: false);
  check(gate.paywallTriggerFor(gate.canPlayLevel(noSpeech, StageId.pronunciation, 1).reason) == null,
      'no paywall when speech unavailable');

  print('[4] adaptive weighting');
  final t = ErrorTracker();
  t.recordWrong('weak');
  t.recordWrong('weak');
  t.recordCorrect('strong');
  check(t.weightFor('weak') > t.weightFor('strong'), 'missed jamo weighted up');
  for (var i = 0; i < 5; i++) {
    t.recordCorrect('weak');
  }
  check(t.weightFor('weak') < 1.0 + (2 / 7) * ErrorTracker.errorWeightFactor, '5-streak decays weight');

  print('[5] curriculum data integrity');
  for (final s in allStage2Targets()) {
    check(isSyllable(s.codePoint), 'stage2 target ${s.char} composable');
  }

  print('\nALL SMOKE CHECKS PASSED');
}
