/// Pronunciation similarity scoring — a REPLACEABLE module (spec §6).
///
/// v1 ships [JamoSimilarityScorer]: decompose target and transcript into
/// jamo sequences and compute a phonetically-weighted edit distance. A later
/// acoustic model (or server scorer) implements the same interface.
library;

import '../../core/hangul/hangul.dart';
import 'speech.dart';

class PronunciationScore {
  const PronunciationScore({
    required this.score,
    required this.perJamoFeedback,
  });

  /// 0..100.
  final int score;

  /// jamo id → matched? Drives the visual feedback ring.
  final Map<String, bool> perJamoFeedback;
}

abstract class PronunciationScorer {
  PronunciationScore score(String target, RecognitionResult result);
}

class JamoSimilarityScorer implements PronunciationScorer {
  const JamoSimilarityScorer();

  /// Confusable jamo pairs get partial credit instead of a full miss —
  /// learners conflating ㅂ/ㅍ shouldn't score zero on the syllable.
  static const _confusablePairs = <String, Set<String>>{
    'c_bieup': {'c_pieup', 'c_ssangbieup'},
    'c_pieup': {'c_bieup'},
    'c_giyeok': {'c_kieuk', 'c_ssanggiyeok'},
    'c_kieuk': {'c_giyeok'},
    'c_digeut': {'c_tieut', 'c_ssangdigeut'},
    'c_tieut': {'c_digeut'},
    'c_jieut': {'c_chieut', 'c_ssangjieut'},
    'c_chieut': {'c_jieut'},
    'v_eo': {'v_o'},
    'v_o': {'v_eo'},
    'v_u': {'v_eu'},
    'v_eu': {'v_u'},
    'v_ae': {'v_e'},
    'v_e': {'v_ae'},
  };

  @override
  PronunciationScore score(String target, RecognitionResult result) {
    final targetIds = jamoIdsInWord(target);
    final heardIds = jamoIdsInWord(result.transcript);
    if (targetIds.isEmpty) {
      return const PronunciationScore(score: 0, perJamoFeedback: {});
    }

    final feedback = <String, bool>{};
    var credit = 0.0;
    for (var i = 0; i < targetIds.length; i++) {
      final want = targetIds[i];
      final got = i < heardIds.length ? heardIds[i] : null;
      if (got == want) {
        credit += 1.0;
        feedback[want] = true;
      } else if (got != null &&
          (_confusablePairs[want]?.contains(got) ?? false)) {
        credit += 0.5;
        feedback[want] = false;
      } else {
        feedback[want] = false;
      }
    }

    // Length mismatch penalty (extra or missing syllables).
    final lengthPenalty =
        (targetIds.length - heardIds.length).abs() / targetIds.length;
    var raw = (credit / targetIds.length) * (1.0 - 0.3 * lengthPenalty);

    // Low recognizer confidence caps the score: don't reward noise.
    raw *= (0.6 + 0.4 * result.confidence.clamp(0.0, 1.0));

    return PronunciationScore(
      score: (raw * 100).round().clamp(0, 100),
      perJamoFeedback: feedback,
    );
  }
}
