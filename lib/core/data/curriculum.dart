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
  StageLevel(stage: StageId.jamoHunt, level: 1, title: 'Basic consonants I', jamoIds: ['c_giyeok', 'c_nieun', 'c_digeut', 'c_rieul', 'c_mieum']),
  StageLevel(stage: StageId.jamoHunt, level: 2, title: 'Basic consonants II', jamoIds: ['c_bieup', 'c_siot', 'c_ieung', 'c_jieut', 'c_hieut']),
  StageLevel(stage: StageId.jamoHunt, level: 3, title: 'Aspirated consonants', jamoIds: ['c_chieut', 'c_kieuk', 'c_tieut', 'c_pieup']),
  StageLevel(stage: StageId.jamoHunt, level: 4, title: 'Basic vowels I', jamoIds: ['v_a', 'v_eo', 'v_o', 'v_u', 'v_eu', 'v_i']),
  StageLevel(stage: StageId.jamoHunt, level: 5, title: 'Basic vowels II', jamoIds: ['v_ya', 'v_yeo', 'v_yo', 'v_yu']),
  StageLevel(stage: StageId.jamoHunt, level: 6, title: 'Tense consonants', jamoIds: _tenseConsonants),
  StageLevel(stage: StageId.jamoHunt, level: 7, title: 'Compound vowels', jamoIds: _complexVowels),
];

/// Stage 2 — block builder: assemble syllables. Levels 1–5 free, 6+ premium
/// (boundary enforced by ContentGate, not here).
const List<StageLevel> stage2Levels = [
  StageLevel(stage: StageId.blockBuilder, level: 1, title: 'First syllables', jamoIds: ['c_giyeok', 'c_nieun', 'v_a', 'v_i'], syllableTargets: ['가', '나', '기', '니']),
  StageLevel(stage: StageId.blockBuilder, level: 2, title: 'Vertical vowels', jamoIds: ['c_mieum', 'c_bieup', 'v_a', 'v_eo', 'v_i'], syllableTargets: ['마', '버', '미', '비', '머']),
  StageLevel(stage: StageId.blockBuilder, level: 3, title: 'Horizontal vowels', jamoIds: ['c_giyeok', 'c_siot', 'v_o', 'v_u', 'v_eu'], syllableTargets: ['고', '구', '소', '수', '스']),
  StageLevel(stage: StageId.blockBuilder, level: 4, title: 'First batchim', jamoIds: ['f_nieun', 'f_rieul', 'f_mieum'], syllableTargets: ['간', '길', '김', '물', '문']),
  StageLevel(stage: StageId.blockBuilder, level: 5, title: 'Batchim ㅇ and ㅂ', jamoIds: ['f_ieung', 'f_bieup'], syllableTargets: ['강', '방', '집', '밥', '상']),
  StageLevel(stage: StageId.blockBuilder, level: 6, title: 'Aspirated syllables', jamoIds: ['c_chieut', 'c_kieuk', 'c_tieut', 'c_pieup'], syllableTargets: ['차', '코', '토', '파', '피']),
  StageLevel(stage: StageId.blockBuilder, level: 7, title: 'Tense syllables', jamoIds: _tenseConsonants, syllableTargets: ['까', '떡', '빵', '쌀', '찌']),
  StageLevel(stage: StageId.blockBuilder, level: 8, title: 'Compound vowel syllables', jamoIds: ['v_wa', 'v_wi', 'v_ae', 'v_e'], syllableTargets: ['과', '귀', '개', '게', '왜']),
  StageLevel(stage: StageId.blockBuilder, level: 9, title: 'Double batchim', jamoIds: ['f_lg', 'f_bs', 'f_nh'], syllableTargets: ['닭', '값', '많']),
];

/// Stage 3 — word rush (premium).
const List<StageLevel> stage3Levels = [
  StageLevel(stage: StageId.wordRush, level: 1, title: 'Food', jamoIds: [], wordIds: ['w_kimchi', 'w_bap', 'w_mul', 'w_uyu', 'w_tteok', 'w_sagwa']),
  StageLevel(stage: StageId.wordRush, level: 2, title: 'Korean dishes', jamoIds: [], wordIds: ['w_bibimbap', 'w_bulgogi', 'w_ramyeon', 'w_gimbap', 'w_chimaek', 'w_coffee']),
  StageLevel(stage: StageId.wordRush, level: 3, title: 'Feelings', jamoIds: [], wordIds: ['w_sarang', 'w_haengbok', 'w_gibun', 'w_nunmul', 'w_useum', 'w_maeum', 'w_kkum']),
  StageLevel(stage: StageId.wordRush, level: 4, title: 'Everyday words', jamoIds: [], wordIds: ['w_annyeong', 'w_gamsa', 'w_chingu', 'w_jip', 'w_hakgyo', 'w_beoseu']),
  StageLevel(stage: StageId.wordRush, level: 5, title: 'Everyday words II', jamoIds: [], wordIds: ['w_jeonhwa', 'w_norae', 'w_chum', 'w_haneul', 'w_bada']),
  StageLevel(stage: StageId.wordRush, level: 6, title: 'K-culture', jamoIds: [], wordIds: ['w_hanbok', 'w_deurama', 'w_yeonghwa', 'w_gasu', 'w_baeu', 'w_eungwon', 'w_mudae', 'w_paen']),
  StageLevel(stage: StageId.wordRush, level: 7, title: 'Snacks & sweets', jamoIds: [], wordIds: ['w_tteokbokki', 'w_mandu', 'w_ppang', 'w_gyeran', 'w_aiseukeurim', 'w_keikeu', 'w_satang', 'w_chokollit']),
  StageLevel(stage: StageId.wordRush, level: 8, title: 'Fruit & vegetables', jamoIds: [], wordIds: ['w_subak', 'w_ttalgi', 'w_banana', 'w_podo', 'w_oksusu', 'w_gamja', 'w_danggeun']),
  StageLevel(stage: StageId.wordRush, level: 9, title: 'Drinks & dining', jamoIds: [], wordIds: ['w_juseu', 'w_cha', 'w_maekju', 'w_soju', 'w_pija', 'w_haembeogeo', 'w_samgyeopsal', 'w_saengseon']),
  StageLevel(stage: StageId.wordRush, level: 10, title: 'Pets & farm animals', jamoIds: [], wordIds: ['w_goyangi', 'w_gangaji', 'w_tokki', 'w_dwaeji', 'w_so', 'w_dak', 'w_ori', 'w_mal', 'w_yang']),
  StageLevel(stage: StageId.wordRush, level: 11, title: 'Wild animals', jamoIds: [], wordIds: ['w_gom', 'w_horangi', 'w_saja', 'w_wonsungi', 'w_kokkiri', 'w_panda', 'w_baem']),
  StageLevel(stage: StageId.wordRush, level: 12, title: 'Small creatures', jamoIds: [], wordIds: ['w_sae', 'w_mulgogi', 'w_nabi', 'w_geobugi', 'w_beol', 'w_gaemi']),
  StageLevel(stage: StageId.wordRush, level: 13, title: 'Sky & weather', jamoIds: [], wordIds: ['w_hae', 'w_dal', 'w_byeol', 'w_bi', 'w_nun', 'w_gureum', 'w_baram', 'w_mujigae']),
  StageLevel(stage: StageId.wordRush, level: 14, title: 'Nature', jamoIds: [], wordIds: ['w_san', 'w_kkot', 'w_namu', 'w_bul', 'w_gang', 'w_seom', 'w_dol']),
  StageLevel(stage: StageId.wordRush, level: 15, title: 'Around town', jamoIds: [], wordIds: ['w_byeongwon', 'w_eunhaeng', 'w_pyeonuijeom', 'w_sikdang', 'w_kape', 'w_doseogwan', 'w_gongwon']),
  StageLevel(stage: StageId.wordRush, level: 16, title: 'Places to visit', jamoIds: [], wordIds: ['w_gonghang', 'w_hotel', 'w_jeol', 'w_sijang', 'w_hwajangsil', 'w_ucheguk', 'w_gyeongchalseo']),
  StageLevel(stage: StageId.wordRush, level: 17, title: 'Getting around', jamoIds: [], wordIds: ['w_taeksi', 'w_jihacheol', 'w_gicha', 'w_bihaenggi', 'w_jajeongeo', 'w_bae', 'w_jadongcha', 'w_otobai']),
  StageLevel(stage: StageId.wordRush, level: 18, title: 'My body', jamoIds: [], wordIds: ['w_son', 'w_bal', 'w_gwi', 'w_ko', 'w_ip', 'w_eolgul', 'w_i_tooth']),
  StageLevel(stage: StageId.wordRush, level: 19, title: 'Family', jamoIds: [], wordIds: ['w_eomma', 'w_appa', 'w_agi', 'w_halmeoni', 'w_harabeoji', 'w_oppa', 'w_eonni']),
  StageLevel(stage: StageId.wordRush, level: 20, title: 'People at work', jamoIds: [], wordIds: ['w_seonsaengnim', 'w_uisa', 'w_haksaeng', 'w_gyeongchal', 'w_yorisa', 'w_hoesawon']),
  StageLevel(stage: StageId.wordRush, level: 21, title: 'Things I carry', jamoIds: [], wordIds: ['w_chaek', 'w_gabang', 'w_sigye', 'w_usan', 'w_moja', 'w_sinbal', 'w_ot', 'w_angyeong']),
  StageLevel(stage: StageId.wordRush, level: 22, title: 'Things at home', jamoIds: [], wordIds: ['w_yeolsoe', 'w_keompyuteo', 'w_sajin', 'w_don', 'w_pyeonji', 'w_seonmul', 'w_haendeupon']),
  StageLevel(stage: StageId.wordRush, level: 23, title: 'Around the room', jamoIds: [], wordIds: ['w_uija', 'w_chimdae', 'w_mun', 'w_yeonpil', 'w_gong', 'w_changmun']),
  StageLevel(stage: StageId.wordRush, level: 24, title: 'Fun Korean words', jamoIds: [], wordIds: ['w_hwaiting', 'w_daebak', 'w_noraebang', 'w_hangeul', 'w_saengil', 'w_chukha']),
  StageLevel(stage: StageId.wordRush, level: 25, title: 'Free time', jamoIds: [], wordIds: ['w_yeohaeng', 'w_geim', 'w_undong', 'w_gongbu', 'w_syoping', 'w_keopeul']),
];

/// Stage 4 — pronunciation challenge (premium): re-uses stage1/2/3 items.
const List<StageLevel> stage4Levels = [
  StageLevel(stage: StageId.pronunciation, level: 1, title: 'Consonant sounds', jamoIds: _basicConsonants),
  StageLevel(stage: StageId.pronunciation, level: 2, title: 'Vowel sounds', jamoIds: _basicVowels),
  StageLevel(stage: StageId.pronunciation, level: 3, title: 'Word sounds', jamoIds: [], wordIds: ['w_annyeong', 'w_gamsa', 'w_sarang', 'w_kimchi', 'w_chingu']),
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
    required this.titleEn,
    required this.goalEn,
    required this.requiredStage1Level,
    required this.requiredStage2Level,
  });

  final int day;
  final String title;
  final String goal;

  /// English copy for learners who can't read Hangul yet (onboarding).
  final String titleEn;
  final String goalEn;
  final int requiredStage1Level;
  final int requiredStage2Level;
}

const List<TrackerDay> sevenDayTracker = [
  TrackerDay(day: 1, title: '자음과 만나기', goal: '기본 자음 10개 인식', titleEn: 'Meet the consonants', goalEn: 'Recognize 10 basic consonants', requiredStage1Level: 2, requiredStage2Level: 0),
  TrackerDay(day: 2, title: '모음의 원리', goal: '기본 모음 6개 + 첫 글자 조립', titleEn: 'How vowels work', goalEn: '6 basic vowels + your first syllable', requiredStage1Level: 4, requiredStage2Level: 1),
  TrackerDay(day: 3, title: '글자 조립 I', goal: '세로·가로 모음 글자 조립', titleEn: 'Building blocks', goalEn: 'Stack vertical & horizontal vowels', requiredStage1Level: 5, requiredStage2Level: 3),
  TrackerDay(day: 4, title: '받침의 발견', goal: '받침 있는 글자 조립', titleEn: 'Final consonants', goalEn: 'Syllables with a batchim', requiredStage1Level: 5, requiredStage2Level: 5),
  TrackerDay(day: 5, title: '어려운 소리', goal: '쌍자음·거센소리 마스터', titleEn: 'Tricky sounds', goalEn: 'Tense & aspirated consonants', requiredStage1Level: 7, requiredStage2Level: 7),
  TrackerDay(day: 6, title: '단어 읽기', goal: '첫 단어 12개 읽기', titleEn: 'Reading words', goalEn: 'Read your first 12 words', requiredStage1Level: 7, requiredStage2Level: 8),
  TrackerDay(day: 7, title: '한글 완독', goal: '어떤 글자든 소리 내어 읽기', titleEn: 'Fluent reader', goalEn: 'Sound out any syllable', requiredStage1Level: 7, requiredStage2Level: 9),
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
