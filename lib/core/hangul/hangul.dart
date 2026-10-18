/// Core Hangul composition engine.
///
/// Unicode syllable math: a precomposed syllable is
///   0xAC00 + (choseong * 588) + (jungseong * 28) + jongseong
/// where choseong ∈ [0,18], jungseong ∈ [0,20], jongseong ∈ [0,27]
/// (jongseong 0 = none). This module is pure Dart with no Flutter deps so it
/// can be unit-tested and reused verbatim on any platform target.
library;

const int syllableBase = 0xAC00;
const int choseongCount = 19;
const int jungseongCount = 21;
const int jongseongCount = 28; // includes "no batchim" at index 0
const int syllableCount = choseongCount * jungseongCount * jongseongCount;

/// Role a jamo block plays inside a syllable. Drives both game logic and the
/// stage-2 assembly slot colors.
enum JamoRole { choseong, jungseong, jongseong }

/// Visual layout of a syllable, determined by its vowel. Drives the slot
/// morphing animation in the assembly puzzle.
enum SyllableLayout {
  /// Vertical vowel (ㅏㅐㅑㅒㅓㅔㅕㅖㅣ): consonant sits left, vowel right.
  vertical,

  /// Horizontal vowel (ㅗㅛㅜㅠㅡ): consonant on top, vowel below.
  horizontal,

  /// Compound vowel (ㅘㅙㅚㅝㅞㅟㅢ): wraps below and to the right.
  mixed,
}

/// How a consonant's shape encodes its articulator — the "sound-shape
/// principle" shown on codex cards.
enum Articulator { velar, alveolar, labial, dental, glottal }

class Jamo {
  const Jamo({
    required this.id,
    required this.char,
    required this.index,
    required this.role,
    required this.nameKo,
    required this.romanization,
    this.articulator,
    this.cheonjiin,
    this.exampleWords = const [],
    this.hint,
  });

  /// Stable asset/logic id, e.g. `c_giyeok`, `v_a`.
  final String id;

  /// Compatibility jamo character (U+3131..U+3163) for display.
  final String char;

  /// Index within its role table (choseong/jungseong/jongseong index).
  final int index;
  final JamoRole role;
  final String nameKo;
  final String romanization;

  /// Consonants only: which articulator the letterform depicts.
  final Articulator? articulator;

  /// Vowels only: cheonji'in (천지인) decomposition, e.g. `ㅣ+ㆍ` for ㅏ.
  final String? cheonjiin;
  final List<String> exampleWords;

  /// One-line teaching hint surfaced on wrong placement.
  final String? hint;
}

// ---------------------------------------------------------------------------
// Jamo tables (index order matches Unicode composition order).
// ---------------------------------------------------------------------------

const List<Jamo> choseongTable = [
  Jamo(id: 'c_giyeok', char: 'ㄱ', index: 0, role: JamoRole.choseong, nameKo: '기역', romanization: 'g/k', articulator: Articulator.velar, exampleWords: ['가방', '고기'], hint: '혀뿌리가 목구멍을 막는 모양이에요'),
  Jamo(id: 'c_ssanggiyeok', char: 'ㄲ', index: 1, role: JamoRole.choseong, nameKo: '쌍기역', romanization: 'kk', articulator: Articulator.velar, exampleWords: ['까치', '꿈']),
  Jamo(id: 'c_nieun', char: 'ㄴ', index: 2, role: JamoRole.choseong, nameKo: '니은', romanization: 'n', articulator: Articulator.alveolar, exampleWords: ['나무', '노래'], hint: '혀끝이 윗잇몸에 닿는 모양이에요'),
  Jamo(id: 'c_digeut', char: 'ㄷ', index: 3, role: JamoRole.choseong, nameKo: '디귿', romanization: 'd/t', articulator: Articulator.alveolar, exampleWords: ['달', '두부']),
  Jamo(id: 'c_ssangdigeut', char: 'ㄸ', index: 4, role: JamoRole.choseong, nameKo: '쌍디귿', romanization: 'tt', articulator: Articulator.alveolar, exampleWords: ['딸기', '떡']),
  Jamo(id: 'c_rieul', char: 'ㄹ', index: 5, role: JamoRole.choseong, nameKo: '리을', romanization: 'r/l', articulator: Articulator.alveolar, exampleWords: ['라면', '노을']),
  Jamo(id: 'c_mieum', char: 'ㅁ', index: 6, role: JamoRole.choseong, nameKo: '미음', romanization: 'm', articulator: Articulator.labial, exampleWords: ['물', '마음'], hint: '입술 모양을 본뜬 글자예요'),
  Jamo(id: 'c_bieup', char: 'ㅂ', index: 7, role: JamoRole.choseong, nameKo: '비읍', romanization: 'b/p', articulator: Articulator.labial, exampleWords: ['바다', '비빔밥']),
  Jamo(id: 'c_ssangbieup', char: 'ㅃ', index: 8, role: JamoRole.choseong, nameKo: '쌍비읍', romanization: 'pp', articulator: Articulator.labial, exampleWords: ['빵', '뽀뽀']),
  Jamo(id: 'c_siot', char: 'ㅅ', index: 9, role: JamoRole.choseong, nameKo: '시옷', romanization: 's', articulator: Articulator.dental, exampleWords: ['사랑', '수박'], hint: '이(치아) 모양을 본뜬 글자예요'),
  Jamo(id: 'c_ssangsiot', char: 'ㅆ', index: 10, role: JamoRole.choseong, nameKo: '쌍시옷', romanization: 'ss', articulator: Articulator.dental, exampleWords: ['쌀', '씨앗']),
  Jamo(id: 'c_ieung', char: 'ㅇ', index: 11, role: JamoRole.choseong, nameKo: '이응', romanization: '(silent)/ng', articulator: Articulator.glottal, exampleWords: ['아침', '우유'], hint: '첫소리에서는 소리가 없고, 받침에서는 "응" 소리가 나요'),
  Jamo(id: 'c_jieut', char: 'ㅈ', index: 12, role: JamoRole.choseong, nameKo: '지읒', romanization: 'j', articulator: Articulator.dental, exampleWords: ['자전거', '주스']),
  Jamo(id: 'c_ssangjieut', char: 'ㅉ', index: 13, role: JamoRole.choseong, nameKo: '쌍지읒', romanization: 'jj', articulator: Articulator.dental, exampleWords: ['짜장면', '찌개']),
  Jamo(id: 'c_chieut', char: 'ㅊ', index: 14, role: JamoRole.choseong, nameKo: '치읓', romanization: 'ch', articulator: Articulator.dental, exampleWords: ['치즈', '춤']),
  Jamo(id: 'c_kieuk', char: 'ㅋ', index: 15, role: JamoRole.choseong, nameKo: '키읔', romanization: 'k', articulator: Articulator.velar, exampleWords: ['커피', '코']),
  Jamo(id: 'c_tieut', char: 'ㅌ', index: 16, role: JamoRole.choseong, nameKo: '티읕', romanization: 't', articulator: Articulator.alveolar, exampleWords: ['토마토', '태양']),
  Jamo(id: 'c_pieup', char: 'ㅍ', index: 17, role: JamoRole.choseong, nameKo: '피읖', romanization: 'p', articulator: Articulator.labial, exampleWords: ['포도', '피자']),
  Jamo(id: 'c_hieut', char: 'ㅎ', index: 18, role: JamoRole.choseong, nameKo: '히읗', romanization: 'h', articulator: Articulator.glottal, exampleWords: ['하늘', '행복'], hint: '목구멍에서 나오는 숨소리를 본뜬 글자예요'),
];

const List<Jamo> jungseongTable = [
  Jamo(id: 'v_a', char: 'ㅏ', index: 0, role: JamoRole.jungseong, nameKo: '아', romanization: 'a', cheonjiin: 'ㅣ + ㆍ', exampleWords: ['아기', '바다']),
  Jamo(id: 'v_ae', char: 'ㅐ', index: 1, role: JamoRole.jungseong, nameKo: '애', romanization: 'ae', cheonjiin: 'ㅏ + ㅣ', exampleWords: ['개', '노래']),
  Jamo(id: 'v_ya', char: 'ㅑ', index: 2, role: JamoRole.jungseong, nameKo: '야', romanization: 'ya', cheonjiin: 'ㅣ + ㆍㆍ', exampleWords: ['야구', '이야기']),
  Jamo(id: 'v_yae', char: 'ㅒ', index: 3, role: JamoRole.jungseong, nameKo: '얘', romanization: 'yae', cheonjiin: 'ㅑ + ㅣ', exampleWords: ['얘기']),
  Jamo(id: 'v_eo', char: 'ㅓ', index: 4, role: JamoRole.jungseong, nameKo: '어', romanization: 'eo', cheonjiin: 'ㆍ + ㅣ', exampleWords: ['어머니', '버스']),
  Jamo(id: 'v_e', char: 'ㅔ', index: 5, role: JamoRole.jungseong, nameKo: '에', romanization: 'e', cheonjiin: 'ㅓ + ㅣ', exampleWords: ['가게', '세상']),
  Jamo(id: 'v_yeo', char: 'ㅕ', index: 6, role: JamoRole.jungseong, nameKo: '여', romanization: 'yeo', cheonjiin: 'ㆍㆍ + ㅣ', exampleWords: ['여름', '연필']),
  Jamo(id: 'v_ye', char: 'ㅖ', index: 7, role: JamoRole.jungseong, nameKo: '예', romanization: 'ye', cheonjiin: 'ㅕ + ㅣ', exampleWords: ['예술', '시계']),
  Jamo(id: 'v_o', char: 'ㅗ', index: 8, role: JamoRole.jungseong, nameKo: '오', romanization: 'o', cheonjiin: 'ㆍ + ㅡ', exampleWords: ['오리', '고구마']),
  Jamo(id: 'v_wa', char: 'ㅘ', index: 9, role: JamoRole.jungseong, nameKo: '와', romanization: 'wa', cheonjiin: 'ㅗ + ㅏ', exampleWords: ['과일', '사과']),
  Jamo(id: 'v_wae', char: 'ㅙ', index: 10, role: JamoRole.jungseong, nameKo: '왜', romanization: 'wae', cheonjiin: 'ㅗ + ㅐ', exampleWords: ['돼지']),
  Jamo(id: 'v_oe', char: 'ㅚ', index: 11, role: JamoRole.jungseong, nameKo: '외', romanization: 'oe', cheonjiin: 'ㅗ + ㅣ', exampleWords: ['외국', '회사']),
  Jamo(id: 'v_yo', char: 'ㅛ', index: 12, role: JamoRole.jungseong, nameKo: '요', romanization: 'yo', cheonjiin: 'ㆍㆍ + ㅡ', exampleWords: ['요리', '교실']),
  Jamo(id: 'v_u', char: 'ㅜ', index: 13, role: JamoRole.jungseong, nameKo: '우', romanization: 'u', cheonjiin: 'ㅡ + ㆍ', exampleWords: ['우유', '구름']),
  Jamo(id: 'v_wo', char: 'ㅝ', index: 14, role: JamoRole.jungseong, nameKo: '워', romanization: 'wo', cheonjiin: 'ㅜ + ㅓ', exampleWords: ['원숭이']),
  Jamo(id: 'v_we', char: 'ㅞ', index: 15, role: JamoRole.jungseong, nameKo: '웨', romanization: 'we', cheonjiin: 'ㅜ + ㅔ', exampleWords: ['웨딩']),
  Jamo(id: 'v_wi', char: 'ㅟ', index: 16, role: JamoRole.jungseong, nameKo: '위', romanization: 'wi', cheonjiin: 'ㅜ + ㅣ', exampleWords: ['위치', '가위']),
  Jamo(id: 'v_yu', char: 'ㅠ', index: 17, role: JamoRole.jungseong, nameKo: '유', romanization: 'yu', cheonjiin: 'ㅡ + ㆍㆍ', exampleWords: ['유리', '휴일']),
  Jamo(id: 'v_eu', char: 'ㅡ', index: 18, role: JamoRole.jungseong, nameKo: '으', romanization: 'eu', cheonjiin: 'ㅡ (땅)', exampleWords: ['그림', '이름']),
  Jamo(id: 'v_ui', char: 'ㅢ', index: 19, role: JamoRole.jungseong, nameKo: '의', romanization: 'ui', cheonjiin: 'ㅡ + ㅣ', exampleWords: ['의자', '의미']),
  Jamo(id: 'v_i', char: 'ㅣ', index: 20, role: JamoRole.jungseong, nameKo: '이', romanization: 'i', cheonjiin: 'ㅣ (사람)', exampleWords: ['이름', '기린']),
];

/// Jongseong (batchim) table. Index 0 is "none" and has no Jamo entry;
/// entries here start at index 1.
const List<Jamo> jongseongTable = [
  Jamo(id: 'f_giyeok', char: 'ㄱ', index: 1, role: JamoRole.jongseong, nameKo: '기역 받침', romanization: 'k', exampleWords: ['책', '음악']),
  Jamo(id: 'f_ssanggiyeok', char: 'ㄲ', index: 2, role: JamoRole.jongseong, nameKo: '쌍기역 받침', romanization: 'k', exampleWords: ['밖']),
  Jamo(id: 'f_gs', char: 'ㄳ', index: 3, role: JamoRole.jongseong, nameKo: '기역시옷 받침', romanization: 'k', exampleWords: ['몫']),
  Jamo(id: 'f_nieun', char: 'ㄴ', index: 4, role: JamoRole.jongseong, nameKo: '니은 받침', romanization: 'n', exampleWords: ['눈', '산']),
  Jamo(id: 'f_nj', char: 'ㄵ', index: 5, role: JamoRole.jongseong, nameKo: '니은지읒 받침', romanization: 'n', exampleWords: ['앉다']),
  Jamo(id: 'f_nh', char: 'ㄶ', index: 6, role: JamoRole.jongseong, nameKo: '니은히읗 받침', romanization: 'n', exampleWords: ['많다']),
  Jamo(id: 'f_digeut', char: 'ㄷ', index: 7, role: JamoRole.jongseong, nameKo: '디귿 받침', romanization: 't', exampleWords: ['곧']),
  Jamo(id: 'f_rieul', char: 'ㄹ', index: 8, role: JamoRole.jongseong, nameKo: '리을 받침', romanization: 'l', exampleWords: ['물', '별']),
  Jamo(id: 'f_lg', char: 'ㄺ', index: 9, role: JamoRole.jongseong, nameKo: '리을기역 받침', romanization: 'k', exampleWords: ['닭']),
  Jamo(id: 'f_lm', char: 'ㄻ', index: 10, role: JamoRole.jongseong, nameKo: '리을미음 받침', romanization: 'm', exampleWords: ['삶']),
  Jamo(id: 'f_lb', char: 'ㄼ', index: 11, role: JamoRole.jongseong, nameKo: '리을비읍 받침', romanization: 'l', exampleWords: ['여덟']),
  Jamo(id: 'f_ls', char: 'ㄽ', index: 12, role: JamoRole.jongseong, nameKo: '리을시옷 받침', romanization: 'l', exampleWords: ['외곬']),
  Jamo(id: 'f_lt', char: 'ㄾ', index: 13, role: JamoRole.jongseong, nameKo: '리을티읕 받침', romanization: 'l', exampleWords: ['핥다']),
  Jamo(id: 'f_lp', char: 'ㄿ', index: 14, role: JamoRole.jongseong, nameKo: '리을피읖 받침', romanization: 'p', exampleWords: ['읊다']),
  Jamo(id: 'f_lh', char: 'ㅀ', index: 15, role: JamoRole.jongseong, nameKo: '리을히읗 받침', romanization: 'l', exampleWords: ['잃다']),
  Jamo(id: 'f_mieum', char: 'ㅁ', index: 16, role: JamoRole.jongseong, nameKo: '미음 받침', romanization: 'm', exampleWords: ['봄', '마음']),
  Jamo(id: 'f_bieup', char: 'ㅂ', index: 17, role: JamoRole.jongseong, nameKo: '비읍 받침', romanization: 'p', exampleWords: ['밥', '집']),
  Jamo(id: 'f_bs', char: 'ㅄ', index: 18, role: JamoRole.jongseong, nameKo: '비읍시옷 받침', romanization: 'p', exampleWords: ['값']),
  Jamo(id: 'f_siot', char: 'ㅅ', index: 19, role: JamoRole.jongseong, nameKo: '시옷 받침', romanization: 't', exampleWords: ['옷', '맛']),
  Jamo(id: 'f_ssangsiot', char: 'ㅆ', index: 20, role: JamoRole.jongseong, nameKo: '쌍시옷 받침', romanization: 't', exampleWords: ['있다']),
  Jamo(id: 'f_ieung', char: 'ㅇ', index: 21, role: JamoRole.jongseong, nameKo: '이응 받침', romanization: 'ng', exampleWords: ['강', '사랑'], hint: 'ㅇ은 받침 자리에서 "응" 소리가 나요'),
  Jamo(id: 'f_jieut', char: 'ㅈ', index: 22, role: JamoRole.jongseong, nameKo: '지읒 받침', romanization: 't', exampleWords: ['낮']),
  Jamo(id: 'f_chieut', char: 'ㅊ', index: 23, role: JamoRole.jongseong, nameKo: '치읓 받침', romanization: 't', exampleWords: ['꽃']),
  Jamo(id: 'f_kieuk', char: 'ㅋ', index: 24, role: JamoRole.jongseong, nameKo: '키읔 받침', romanization: 'k', exampleWords: ['부엌']),
  Jamo(id: 'f_tieut', char: 'ㅌ', index: 25, role: JamoRole.jongseong, nameKo: '티읕 받침', romanization: 't', exampleWords: ['끝', '밭']),
  Jamo(id: 'f_pieup', char: 'ㅍ', index: 26, role: JamoRole.jongseong, nameKo: '피읖 받침', romanization: 'p', exampleWords: ['앞', '옆']),
  Jamo(id: 'f_hieut', char: 'ㅎ', index: 27, role: JamoRole.jongseong, nameKo: '히읗 받침', romanization: 't', exampleWords: ['좋다']),
];

/// Decomposed view of one precomposed syllable.
class Syllable {
  const Syllable({
    required this.choseong,
    required this.jungseong,
    required this.jongseong,
  })  : assert(choseong >= 0 && choseong < choseongCount),
        assert(jungseong >= 0 && jungseong < jungseongCount),
        assert(jongseong >= 0 && jongseong < jongseongCount);

  final int choseong;
  final int jungseong;

  /// 0 means no batchim.
  final int jongseong;

  int get codePoint =>
      syllableBase + choseong * 588 + jungseong * 28 + jongseong;

  String get char => String.fromCharCode(codePoint);

  bool get hasBatchim => jongseong != 0;

  Jamo get choseongJamo => choseongTable[choseong];
  Jamo get jungseongJamo => jungseongTable[jungseong];

  /// Null when the syllable has no batchim.
  Jamo? get jongseongJamo =>
      jongseong == 0 ? null : jongseongTable[jongseong - 1];

  SyllableLayout get layout => layoutForJungseong(jungseong);

  @override
  bool operator ==(Object other) =>
      other is Syllable &&
      other.choseong == choseong &&
      other.jungseong == jungseong &&
      other.jongseong == jongseong;

  @override
  int get hashCode => Object.hash(choseong, jungseong, jongseong);

  @override
  String toString() => 'Syllable($char)';
}

/// Composes a syllable from role indices. Throws [RangeError] on bad input.
Syllable compose(int choseong, int jungseong, [int jongseong = 0]) {
  if (choseong < 0 || choseong >= choseongCount) {
    throw RangeError.range(choseong, 0, choseongCount - 1, 'choseong');
  }
  if (jungseong < 0 || jungseong >= jungseongCount) {
    throw RangeError.range(jungseong, 0, jungseongCount - 1, 'jungseong');
  }
  if (jongseong < 0 || jongseong >= jongseongCount) {
    throw RangeError.range(jongseong, 0, jongseongCount - 1, 'jongseong');
  }
  return Syllable(
      choseong: choseong, jungseong: jungseong, jongseong: jongseong);
}

/// True if [codePoint] is a precomposed Hangul syllable (가..힣).
bool isSyllable(int codePoint) =>
    codePoint >= syllableBase && codePoint < syllableBase + syllableCount;

/// Decomposes a precomposed syllable code point. Throws [ArgumentError] if
/// [codePoint] is not in the Hangul syllable block.
Syllable decompose(int codePoint) {
  if (!isSyllable(codePoint)) {
    throw ArgumentError.value(
        codePoint, 'codePoint', 'not a Hangul syllable');
  }
  final offset = codePoint - syllableBase;
  return Syllable(
    choseong: offset ~/ 588,
    jungseong: (offset % 588) ~/ 28,
    jongseong: offset % 28,
  );
}

/// Decomposes every syllable of [text]; non-syllable runes pass through as
/// null entries so callers can handle mixed text.
List<Syllable?> decomposeText(String text) => text.runes
    .map((r) => isSyllable(r) ? decompose(r) : null)
    .toList(growable: false);

SyllableLayout layoutForJungseong(int jungseongIndex) {
  const vertical = {0, 1, 2, 3, 4, 5, 6, 7, 20}; // ㅏㅐㅑㅒㅓㅔㅕㅖㅣ
  const horizontal = {8, 12, 13, 17, 18}; // ㅗㅛㅜㅠㅡ
  if (vertical.contains(jungseongIndex)) return SyllableLayout.vertical;
  if (horizontal.contains(jungseongIndex)) return SyllableLayout.horizontal;
  return SyllableLayout.mixed; // ㅘㅙㅚㅝㅞㅟㅢ
}

/// Flattens a word into the jamo ids it exercises — feeds the error tracker
/// and SRS when the player misses a whole word.
List<String> jamoIdsInWord(String word) {
  final ids = <String>[];
  for (final s in decomposeText(word)) {
    if (s == null) continue;
    ids.add(s.choseongJamo.id);
    ids.add(s.jungseongJamo.id);
    final f = s.jongseongJamo;
    if (f != null) ids.add(f.id);
  }
  return ids;
}

/// Lookup any jamo by id across all three tables.
final Map<String, Jamo> jamoById = {
  for (final j in choseongTable) j.id: j,
  for (final j in jungseongTable) j.id: j,
  for (final j in jongseongTable) j.id: j,
};
