/// "Learn Hangul" course: the complete reading curriculum as data — every
/// consonant and vowel, syllable building, final consonants and the core
/// reading rules. Explanations are English-first (learners can't read
/// Korean yet) with Korean terms alongside. Pure Dart; rendered by
/// features/learn.
library;

import '../hangul/hangul.dart';

sealed class LessonBlock {
  const LessonBlock();
}

class LessonText extends LessonBlock {
  const LessonText(this.text);
  final String text;
}

/// Highlighted tip box.
class LessonCallout extends LessonBlock {
  const LessonCallout(this.text);
  final String text;
}

/// Tappable jamo rows (letter, romanization, name, tip, example words).
class LessonJamo extends LessonBlock {
  const LessonJamo(this.ids);
  final List<String> ids;
}

class LessonTable extends LessonBlock {
  const LessonTable(this.header, this.rows);
  final List<String> header;
  final List<List<String>> rows;
}

/// Written form → how it actually sounds → meaning.
class LessonExamples extends LessonBlock {
  const LessonExamples(this.title, this.items);
  final String title;
  final List<(String written, String sounds, String meaning)> items;
}

/// Interactive syllable builder (pick initial + vowel + optional final).
class LessonComposer extends LessonBlock {
  const LessonComposer();
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.titleKo,
    required this.summary,
    required this.blocks,
  });

  final String id;
  final String title;
  final String titleKo;
  final String summary;
  final List<LessonBlock> blocks;
}

/// English pronunciation tips per jamo id (the jamo tables carry Korean
/// names and romanization; these say how to make the sound).
const Map<String, String> jamoTipsEn = {
  // basic vowels
  'v_a': 'a as in "father"',
  'v_ya': 'ya as in "yacht"',
  'v_eo': 'eo — open "o", like "u" in "up"',
  'v_yeo': 'yeo — "y" + eo, like "yu" in "yummy"',
  'v_o': 'o as in "go", lips rounded',
  'v_yo': 'yo as in "yoga"',
  'v_u': 'u as in "moon"',
  'v_yu': 'yu as in "you"',
  'v_eu': 'eu — say "oo" with lips spread flat',
  'v_i': 'i as in "see"',
  // compound vowels
  'v_ae': 'ae — "e" as in "bed" (mouth a little wider)',
  'v_yae': 'yae — "ye" as in "yes"',
  'v_e': 'e as in "bed" (same as ㅐ for most speakers)',
  'v_ye': 'ye as in "yes"',
  'v_wa': 'wa as in "wander"',
  'v_wae': 'wae as in "wet"',
  'v_oe': 'oe — today usually "we" as in "wet"',
  'v_wo': 'wo as in "won"',
  'v_we': 'we as in "wet"',
  'v_wi': 'wi as in "we"',
  'v_ui': 'ui — "eu" gliding into "i"',
  // basic consonants
  'c_giyeok': 'g at the start, k at the end — softer than English k',
  'c_nieun': 'n as in "no"',
  'c_digeut': 'd at the start, t at the end',
  'c_rieul': 'a light tap between r and l; l at the end',
  'c_mieum': 'm as in "mom"',
  'c_bieup': 'b at the start, p at the end',
  'c_siot': 's as in "sun" (sh before ㅣ: 시 = shi)',
  'c_ieung': 'silent at the start, ng at the end',
  'c_jieut': 'j as in "jam"',
  'c_chieut': 'ch with a strong puff of air',
  'c_kieuk': 'k with a strong puff of air',
  'c_tieut': 't with a strong puff of air',
  'c_pieup': 'p with a strong puff of air',
  'c_hieut': 'h as in "hat"',
  // tense consonants
  'c_ssanggiyeok': 'kk — tight throat, no air: like "k" in "sky"',
  'c_ssangdigeut': 'tt — tight, no air: like "t" in "stop"',
  'c_ssangbieup': 'pp — tight, no air: like "p" in "spy"',
  'c_ssangsiot': 'ss — a sharp, tense s',
  'c_ssangjieut': 'jj — tight, no air: like "ts" in "cats"',
};

const List<Lesson> hangulCourse = [
  Lesson(
    id: 'intro',
    title: 'What is Hangul?',
    titleKo: '한글이란',
    summary: '24 letters that snap into blocks',
    blocks: [
      LessonText('Hangul (한글) is the Korean alphabet, created in 1443 by King '
          'Sejong so that anyone could learn to read. It has 24 basic '
          'letters: 14 consonants (자음) and 10 vowels (모음).'),
      LessonText(
          'Letters are not written in a line like English. They stack into '
          'square syllable blocks — one block = one syllable. Read each block '
          'left → right, top → bottom.'),
      LessonTable([
        'Block',
        'Letters',
        'Sound'
      ], [
        ['한', 'ㅎ h + ㅏ a + ㄴ n', 'han'],
        ['글', 'ㄱ g + ㅡ eu + ㄹ l', 'geul'],
      ]),
      LessonCallout(
          'Every block has at least one consonant and one vowel. When a '
          'syllable starts with a vowel sound, the silent ㅇ fills the '
          'consonant spot: 아 = a, 이 = i.'),
      LessonText('In the next lessons you will meet every vowel and consonant, '
          'build blocks yourself, then learn the few rules that change how '
          'words sound. Tap any letter to hear it.'),
    ],
  ),
  Lesson(
    id: 'vowels',
    title: 'Basic vowels',
    titleKo: '기본 모음',
    summary: '10 vowels from 3 simple strokes',
    blocks: [
      LessonText(
          'Vowels are built from three strokes: a dot for the sky (ㆍ), a '
          'flat line for the earth (ㅡ) and a standing line for a person (ㅣ). '
          'Today the dot is written as a short stroke.'),
      LessonCallout('Add a second short stroke and you add a "y" sound: '
          'ㅏ a → ㅑ ya, ㅓ eo → ㅕ yeo, ㅗ o → ㅛ yo, ㅜ u → ㅠ yu.'),
      LessonJamo([
        'v_a', 'v_ya', 'v_eo', 'v_yeo', 'v_o', //
        'v_yo', 'v_u', 'v_yu', 'v_eu', 'v_i',
      ]),
      LessonText(
          'Tall vowels (ㅏ ㅑ ㅓ ㅕ ㅣ) sit to the RIGHT of the consonant: 가. '
          'Flat vowels (ㅗ ㅛ ㅜ ㅠ ㅡ) sit BELOW it: 고.'),
    ],
  ),
  Lesson(
    id: 'consonants',
    title: 'Basic consonants',
    titleKo: '기본 자음',
    summary: '14 consonants shaped like your mouth',
    blocks: [
      LessonText(
          'The five core consonants are pictures of how your mouth makes the '
          'sound: ㄱ the tongue root blocking the throat, ㄴ the tongue tip on '
          'the gum ridge, ㅁ the closed mouth, ㅅ a tooth, ㅇ the open throat.'),
      LessonTable([
        'Base',
        '+ stroke',
        '+ stroke'
      ], [
        ['ㄱ g', 'ㅋ k', ''],
        ['ㄴ n', 'ㄷ d', 'ㅌ t'],
        ['ㅁ m', 'ㅂ b', 'ㅍ p'],
        ['ㅅ s', 'ㅈ j', 'ㅊ ch'],
        ['ㅇ (silent)', 'ㅎ h', ''],
      ]),
      LessonCallout(
          'An extra stroke means a stronger sound. Learn the 5 base shapes '
          'and the other 9 follow.'),
      LessonJamo([
        'c_giyeok', 'c_nieun', 'c_digeut', 'c_rieul', 'c_mieum', //
        'c_bieup', 'c_siot', 'c_ieung', 'c_jieut', 'c_chieut',
        'c_kieuk', 'c_tieut', 'c_pieup', 'c_hieut',
      ]),
    ],
  ),
  Lesson(
    id: 'tense',
    title: 'Plain, aspirated, tense',
    titleKo: '예사소리 · 거센소리 · 된소리',
    summary: 'The 3-way contrast and 5 double consonants',
    blocks: [
      LessonText(
          'Korean has three versions of several consonants. Plain sounds are '
          'soft, aspirated ones release a puff of air, and tense ones (the '
          'doubled letters) are tight with no air.'),
      LessonTable([
        'Plain',
        'Aspirated',
        'Tense'
      ], [
        ['ㄱ g', 'ㅋ k', 'ㄲ kk'],
        ['ㄷ d', 'ㅌ t', 'ㄸ tt'],
        ['ㅂ b', 'ㅍ p', 'ㅃ pp'],
        ['ㅅ s', '—', 'ㅆ ss'],
        ['ㅈ j', 'ㅊ ch', 'ㅉ jj'],
      ]),
      LessonCallout(
          'Tissue test: hold a tissue in front of your mouth. Aspirated '
          'sounds make it move; tense sounds keep it still.'),
      LessonJamo([
        'c_ssanggiyeok', 'c_ssangdigeut', 'c_ssangbieup', //
        'c_ssangsiot', 'c_ssangjieut',
      ]),
      LessonExamples('Hear the difference', [
        ('달', 'dal', 'moon'),
        ('탈', 'tal', 'mask'),
        ('딸', 'ttal', 'daughter'),
        ('불', 'bul', 'fire'),
        ('풀', 'pul', 'grass'),
        ('뿔', 'ppul', 'horn'),
      ]),
    ],
  ),
  Lesson(
    id: 'compound',
    title: 'Compound vowels',
    titleKo: '복합 모음',
    summary: '11 vowels made by combining',
    blocks: [
      LessonText('The remaining 11 vowels are combinations of the basic ones — '
          'read the parts and glide them together.'),
      LessonTable([
        'Parts',
        'Vowel',
        'Sound'
      ], [
        ['ㅏ + ㅣ', 'ㅐ', 'ae'],
        ['ㅓ + ㅣ', 'ㅔ', 'e'],
        ['ㅗ + ㅏ', 'ㅘ', 'wa'],
        ['ㅜ + ㅓ', 'ㅝ', 'wo'],
        ['ㅗ + ㅣ', 'ㅚ', 'oe'],
        ['ㅜ + ㅣ', 'ㅟ', 'wi'],
        ['ㅡ + ㅣ', 'ㅢ', 'ui'],
      ]),
      LessonCallout(
          'Shortcuts: ㅐ and ㅔ sound the same for most speakers today, and '
          'ㅙ ㅚ ㅞ all sound like "we".'),
      LessonJamo([
        'v_ae', 'v_yae', 'v_e', 'v_ye', 'v_wa', 'v_wae', //
        'v_oe', 'v_wo', 'v_we', 'v_wi', 'v_ui',
      ]),
    ],
  ),
  Lesson(
    id: 'build',
    title: 'Build a syllable',
    titleKo: '글자 조립',
    summary: 'Put letters together yourself',
    blocks: [
      LessonText('Where each letter goes depends on the vowel: tall vowels go '
          'right of the consonant, flat vowels go below, and combined vowels '
          'wrap around. A final consonant (받침) always goes at the bottom.'),
      LessonTable([
        'Shape',
        'Example',
        'Sound'
      ], [
        ['consonant + tall vowel', '가', 'ga'],
        ['consonant + flat vowel', '고', 'go'],
        ['consonant + combined vowel', '과', 'gwa'],
        ['… + final consonant', '강', 'gang'],
      ]),
      LessonComposer(),
    ],
  ),
  Lesson(
    id: 'batchim',
    title: 'Final consonants',
    titleKo: '받침',
    summary: 'Only 7 sounds at the end of a block',
    blocks: [
      LessonText('A consonant at the bottom of a block is a 받침 (batchim). Many '
          'letters can sit there, but at the end of a syllable they collapse '
          'into just 7 sounds.'),
      LessonTable([
        'Sound',
        'Letters',
        'Example'
      ], [
        ['k', 'ㄱ ㅋ ㄲ', '책 chaek (book)'],
        ['n', 'ㄴ', '산 san (mountain)'],
        ['t', 'ㄷ ㅅ ㅆ ㅈ ㅊ ㅌ ㅎ', '옷 ot (clothes)'],
        ['l', 'ㄹ', '물 mul (water)'],
        ['m', 'ㅁ', '밤 bam (night)'],
        ['p', 'ㅂ ㅍ', '앞 ap (front)'],
        ['ng', 'ㅇ', '강 gang (river)'],
      ]),
      LessonCallout('Double finals (ㄳ ㄵ ㄶ ㄺ ㄻ ㄼ ㄽ ㄾ ㄿ ㅀ ㅄ) are usually read as '
          'just one of the two: 값 → [갑] gap, 닭 → [닥] dak, 앉다 → [안따] anta.'),
    ],
  ),
  Lesson(
    id: 'rules',
    title: 'Reading rules',
    titleKo: '읽기 규칙',
    summary: 'Why words sound different from spelling',
    blocks: [
      LessonText(
          'Korean is spelled by meaning, so a few sound changes happen when '
          'blocks meet. [Brackets] show how a word is actually said.'),
      LessonExamples('Linking (연음): a final slides into a following ㅇ', [
        ('음악', '[으막] eumak', 'music'),
        ('한국어', '[한구거] hangugeo', 'Korean language'),
        ('옷이', '[오시] osi', 'clothes (subject)'),
      ]),
      LessonExamples('Nasalization (비음화): k/t/p before ㄴ ㅁ → ng/n/m', [
        ('국물', '[궁물] gungmul', 'broth'),
        ('감사합니다', '[감사함니다] gamsahamnida', 'thank you'),
        ('십만', '[심만] simman', '100,000'),
      ]),
      LessonExamples('ㅎ + plain → aspirated (격음화)', [
        ('좋다', '[조타] jota', 'good'),
        ('축하', '[추카] chuka', 'congratulations'),
        ('입학', '[이팍] ipak', 'school entrance'),
      ]),
      LessonExamples('Silent ㅎ between vowel sounds', [
        ('좋아요', '[조아요] joayo', 'I like it'),
        ('많이', '[마니] mani', 'a lot'),
      ]),
      LessonExamples('ㄴ next to ㄹ → ㄹㄹ (유음화)', [
        ('신라', '[실라] silla', 'Silla kingdom'),
        ('설날', '[설랄] seollal', 'Lunar New Year'),
      ]),
      LessonExamples(
          'Tensing (경음화): after k/t/p, the next consonant tightens', [
        ('학교', '[학꾜] hakgyo', 'school'),
        ('식당', '[식땅] sikdang', 'restaurant'),
      ]),
      LessonCallout(
          'That is all of Hangul. You can now sound out any Korean word — '
          'go practice it in the stages!'),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Romanization for the syllable builder (Revised Romanization, simplified:
// finals use their representative sound).
// ---------------------------------------------------------------------------

const _initialRoman = [
  'g', 'kk', 'n', 'd', 'tt', 'r', 'm', 'b', 'pp', 's', //
  'ss', '', 'j', 'jj', 'ch', 'k', 't', 'p', 'h',
];
const _vowelRoman = [
  'a', 'ae', 'ya', 'yae', 'eo', 'e', 'yeo', 'ye', 'o', 'wa', 'wae', //
  'oe', 'yo', 'u', 'wo', 'we', 'wi', 'yu', 'eu', 'ui', 'i',
];
// Index = jongseong index (0 = none).
const _finalRoman = [
  '', 'k', 'k', 'k', 'n', 'n', 'n', 't', 'l', 'k', 'm', //
  'l', 'l', 'l', 'p', 'l', 'm', 'p', 'p', 't', 't',
  'ng', 't', 't', 'k', 't', 'p', 't',
];

String romanizeSyllable(Syllable s) =>
    _initialRoman[s.choseong] +
    _vowelRoman[s.jungseong] +
    _finalRoman[s.jongseong];
