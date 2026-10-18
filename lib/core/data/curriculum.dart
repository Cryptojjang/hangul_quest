/// Stage/level curriculum + the 7-day reading tracker.
///
/// Pure data + progression rules. The free/premium boundary itself lives in
/// core/economy/content_gate.dart; this file only describes content order.
library;

import '../hangul/hangul.dart';

enum StageId { jamoHunt, blockBuilder, wordRush, pronunciation }

class StageLevel {
  const StageLevel({
    required this.stage,
    required this.level,
    required this.title,
    required this.jamoIds,
    this.syllableTargets = const [],
    this.wordIds = const [],
  });

  final StageId stage;

  /// 1-based level number within the stage.
  final int level;
  final String title;

  /// Jamo introduced/required by this level.
  final List<String> jamoIds;

  /// Stage 2: syllables to assemble (as strings, e.g. '가').
  final List<String> syllableTargets;

  /// Stage 3: vocab word ids.
  final List<String> wordIds;
}

const _basicConsonants = [
  'c_giyeok', 'c_nieun', 'c_digeut', 'c_rieul', 'c_mieum', 'c_bieup',
  'c_siot', 'c_ieung', 'c_jieut', 'c_chieut', 'c_kieuk', 'c_tieut',
  'c_pieup', 'c_hieut',
];
const _basicVowels = [
  'v_a', 'v_ya', 'v_eo', 'v_yeo', 'v_o', 'v_yo', 'v_u', 'v_yu', 'v_eu', 'v_i',
];
const _tenseConsonants = [
  'c_ssanggiyeok', 'c_ssangdigeut', 'c_ssangbieup', 'c_ssangsiot',
  'c_ssangjieut',
];
const _complexVowels = [
  'v_ae', 'v_yae', 'v_e', 'v_ye', 'v_wa', 'v_wae', 'v_oe', 'v_wo', 'v_we',
  'v_wi', 'v_ui',
];

/// Stage 1 — jamo hunt: recognize sounds.
const List<StageLevel> stage1Levels = [
  StageLevel(stage: StageId.jamoHunt, level: 1, title: '기본 자음 I', jamoIds: ['c_giyeok', 'c_nieun', 'c_digeut', 'c_rieul', 'c_mieum']),
  StageLevel(stage: StageId.jamoHunt, level: 2, title: '기본 자음 II', jamoIds: ['c_bieup', 'c_siot', 'c_ieung', 'c_jieut', 'c_hieut']),
  StageLevel(stage: StageId.jamoHunt, level: 3, title: '거센소리', jamoIds: ['c_chieut', 'c_kieuk', 'c_tieut', 'c_pieup']),
  StageLevel(stage: StageId.jamoHunt, level: 4, title: '기본 모음 I', jamoIds: ['v_a', 'v_eo', 'v_o', 'v_u', 'v_eu', 'v_i']),
  StageLevel(stage: StageId.jamoHunt, level: 5, title: '기본 모음 II', jamoIds: ['v_ya', 'v_yeo', 'v_yo', 'v_yu']),
  StageLevel(stage: StageId.jamoHunt, level: 6, title: '쌍자음', jamoIds: _tenseConsonants),
  StageLevel(stage: StageId.jamoHunt, level: 7, title: '복합 모음', jamoIds: _complexVowels),
];

/// Stage 2 — block builder: assemble syllables. Levels 1–5 free, 6+ premium
/// (boundary enforced by ContentGate, not here).
const List<StageLevel> stage2Levels = [
  StageLevel(stage: StageId.blockBuilder, level: 1, title: '첫 글자', jamoIds: ['c_giyeok', 'c_nieun', 'v_a', 'v_i'], syllableTargets: ['가', '나', '기', '니']),
  StageLevel(stage: StageId.blockBuilder, level: 2, title: '세로 모음', jamoIds: ['c_mieum', 'c_bieup', 'v_a', 'v_eo', 'v_i'], syllableTargets: ['마', '버', '미', '비', '머']),
  StageLevel(stage: StageId.blockBuilder, level: 3, title: '가로 모음', jamoIds: ['c_giyeok', 'c_siot', 'v_o', 'v_u', 'v_eu'], syllableTargets: ['고', '구', '소', '수', '스']),
  StageLevel(stage: StageId.blockBuilder, level: 4, title: '첫 받침', jamoIds: ['f_nieun', 'f_rieul', 'f_mieum'], syllableTargets: ['간', '길', '김', '물', '문']),
  StageLevel(stage: StageId.blockBuilder, level: 5, title: '받침 이응', jamoIds: ['f_ieung', 'f_bieup'], syllableTargets: ['강', '방', '집', '밥', '상']),
  StageLevel(stage: StageId.blockBuilder, level: 6, title: '거센소리 글자', jamoIds: ['c_chieut', 'c_kieuk', 'c_tieut', 'c_pieup'], syllableTargets: ['차', '코', '토', '파', '피']),
  StageLevel(stage: StageId.blockBuilder, level: 7, title: '쌍자음 글자', jamoIds: _tenseConsonants, syllableTargets: ['까', '떡', '빵', '쌀', '찌']),
  StageLevel(stage: StageId.blockBuilder, level: 8, title: '복합 모음 글자', jamoIds: ['v_wa', 'v_wi', 'v_ae', 'v_e'], syllableTargets: ['과', '귀', '개', '게', '왜']),
  StageLevel(stage: StageId.blockBuilder, level: 9, title: '겹받침', jamoIds: ['f_lg', 'f_bs', 'f_nh'], syllableTargets: ['닭', '값', '많']),
];

/// Stage 3 — word rush (premium).
const List<StageLevel> stage3Levels = [
  StageLevel(stage: StageId.wordRush, level: 1, title: '음식', jamoIds: [], wordIds: ['w_kimchi', 'w_bap', 'w_mul', 'w_uyu', 'w_tteok', 'w_sagwa']),
  StageLevel(stage: StageId.wordRush, level: 2, title: '한식 한 상', jamoIds: [], wordIds: ['w_bibimbap', 'w_bulgogi', 'w_ramyeon', 'w_gimbap', 'w_chimaek', 'w_coffee']),
  StageLevel(stage: StageId.wordRush, level: 3, title: '감정', jamoIds: [], wordIds: ['w_sarang', 'w_haengbok', 'w_gibun', 'w_nunmul', 'w_useum', 'w_maeum', 'w_kkum']),
  StageLevel(stage: StageId.wordRush, level: 4, title: '일상 표현', jamoIds: [], wordIds: ['w_annyeong', 'w_gamsa', 'w_chingu', 'w_jip', 'w_hakgyo', 'w_beoseu']),
  StageLevel(stage: StageId.wordRush, level: 5, title: '일상 II', jamoIds: [], wordIds: ['w_jeonhwa', 'w_norae', 'w_chum', 'w_haneul', 'w_bada']),
  StageLevel(stage: StageId.wordRush, level: 6, title: 'K-컬처', jamoIds: [], wordIds: ['w_hanbok', 'w_deurama', 'w_yeonghwa', 'w_gasu', 'w_baeu', 'w_eungwon', 'w_mudae', 'w_paen']),
];

/// Stage 4 — pronunciation challenge (premium): re-uses stage1/2/3 items.
const List<StageLevel> stage4Levels = [
  StageLevel(stage: StageId.pronunciation, level: 1, title: '자음 발음', jamoIds: _basicConsonants),
  StageLevel(stage: StageId.pronunciation, level: 2, title: '모음 발음', jamoIds: _basicVowels),
  StageLevel(stage: StageId.pronunciation, level: 3, title: '단어 발음', jamoIds: [], wordIds: ['w_annyeong', 'w_gamsa', 'w_sarang', 'w_kimchi', 'w_chingu']),
];

List<StageLevel> levelsFor(StageId stage) => switch (stage) {
      StageId.jamoHunt => stage1Levels,
      StageId.blockBuilder => stage2Levels,
      StageId.wordRush => stage3Levels,
      StageId.pronunciation => stage4Levels,
    };

/// 7-day reading promise tracker (onboarding promise §1).
class TrackerDay {
  const TrackerDay({
    required this.day,
    required this.title,
    required this.goal,
    required this.requiredStage1Level,
    required this.requiredStage2Level,
  });

  final int day;
  final String title;
  final String goal;
  final int requiredStage1Level;
  final int requiredStage2Level;
}

const List<TrackerDay> sevenDayTracker = [
  TrackerDay(day: 1, title: '자음과 만나기', goal: '기본 자음 10개 인식', requiredStage1Level: 2, requiredStage2Level: 0),
  TrackerDay(day: 2, title: '모음의 원리', goal: '기본 모음 6개 + 첫 글자 조립', requiredStage1Level: 4, requiredStage2Level: 1),
  TrackerDay(day: 3, title: '글자 조립 I', goal: '세로·가로 모음 글자 조립', requiredStage1Level: 5, requiredStage2Level: 3),
  TrackerDay(day: 4, title: '받침의 발견', goal: '받침 있는 글자 조립', requiredStage1Level: 5, requiredStage2Level: 5),
  TrackerDay(day: 5, title: '어려운 소리', goal: '쌍자음·거센소리 마스터', requiredStage1Level: 7, requiredStage2Level: 7),
  TrackerDay(day: 6, title: '단어 읽기', goal: '첫 단어 12개 읽기', requiredStage1Level: 7, requiredStage2Level: 8),
  TrackerDay(day: 7, title: '한글 완독', goal: '어떤 글자든 소리 내어 읽기', requiredStage1Level: 7, requiredStage2Level: 9),
];

/// Progress (0..1) toward completing [day], given highest cleared levels.
double trackerDayProgress(TrackerDay day, int stage1Cleared, int stage2Cleared) {
  final req1 = day.requiredStage1Level;
  final req2 = day.requiredStage2Level;
  final total = req1 + req2;
  if (total == 0) return 1;
  final done =
      stage1Cleared.clamp(0, req1) + stage2Cleared.clamp(0, req2);
  return done / total;
}

/// All syllable target characters across stage 2 — used to pre-warm audio
/// slots and validate they are real composable syllables.
List<Syllable> allStage2Targets() => [
      for (final l in stage2Levels)
        for (final t in l.syllableTargets) decompose(t.runes.first),
    ];
