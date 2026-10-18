/// Word Rush vocabulary dataset.
///
/// Content policy (spec §3.1): everyday + K-culture COMMON NOUNS only.
/// No trademarked proper nouns (group names, artist names, show titles) and
/// no song lyrics — reviewed against the checklist in docs/PRODUCT_SPEC.md.
library;

enum WordCategory { food, emotion, daily, kculture }

class VocabWord {
  const VocabWord({
    required this.id,
    required this.korean,
    required this.english,
    required this.category,
    required this.imageSlot,
    required this.emoji,
  });

  final String id;
  final String korean;
  final String english;
  final WordCategory category;

  /// Illustration asset slot (art pipeline fills these in).
  final String imageSlot;

  /// Distinct per-word stand-in shown until the slot's illustration lands.
  /// Every emoji is unique across the dataset so image-matching stays
  /// playable in dev builds.
  final String emoji;
}

const List<VocabWord> vocabWords = [
  // --- Food ---
  VocabWord(id: 'w_kimchi', korean: '김치', english: 'kimchi', category: WordCategory.food, imageSlot: 'img/word/kimchi', emoji: '🥬'),
  VocabWord(id: 'w_bibimbap', korean: '비빔밥', english: 'bibimbap', category: WordCategory.food, imageSlot: 'img/word/bibimbap', emoji: '🍲'),
  VocabWord(id: 'w_bap', korean: '밥', english: 'rice / meal', category: WordCategory.food, imageSlot: 'img/word/bap', emoji: '🍚'),
  VocabWord(id: 'w_mul', korean: '물', english: 'water', category: WordCategory.food, imageSlot: 'img/word/mul', emoji: '💧'),
  VocabWord(id: 'w_uyu', korean: '우유', english: 'milk', category: WordCategory.food, imageSlot: 'img/word/uyu', emoji: '🥛'),
  VocabWord(id: 'w_bulgogi', korean: '불고기', english: 'bulgogi', category: WordCategory.food, imageSlot: 'img/word/bulgogi', emoji: '🥩'),
  VocabWord(id: 'w_tteok', korean: '떡', english: 'rice cake', category: WordCategory.food, imageSlot: 'img/word/tteok', emoji: '🍡'),
  VocabWord(id: 'w_ramyeon', korean: '라면', english: 'ramyeon', category: WordCategory.food, imageSlot: 'img/word/ramyeon', emoji: '🍜'),
  VocabWord(id: 'w_gimbap', korean: '김밥', english: 'gimbap', category: WordCategory.food, imageSlot: 'img/word/gimbap', emoji: '🍙'),
  VocabWord(id: 'w_sagwa', korean: '사과', english: 'apple', category: WordCategory.food, imageSlot: 'img/word/sagwa', emoji: '🍎'),
  VocabWord(id: 'w_chimaek', korean: '치킨', english: 'fried chicken', category: WordCategory.food, imageSlot: 'img/word/chikin', emoji: '🍗'),
  VocabWord(id: 'w_coffee', korean: '커피', english: 'coffee', category: WordCategory.food, imageSlot: 'img/word/keopi', emoji: '☕'),
  // --- Emotion ---
  VocabWord(id: 'w_sarang', korean: '사랑', english: 'love', category: WordCategory.emotion, imageSlot: 'img/word/sarang', emoji: '❤️'),
  VocabWord(id: 'w_haengbok', korean: '행복', english: 'happiness', category: WordCategory.emotion, imageSlot: 'img/word/haengbok', emoji: '😊'),
  VocabWord(id: 'w_gibun', korean: '기분', english: 'mood', category: WordCategory.emotion, imageSlot: 'img/word/gibun', emoji: '😌'),
  VocabWord(id: 'w_nunmul', korean: '눈물', english: 'tears', category: WordCategory.emotion, imageSlot: 'img/word/nunmul', emoji: '😢'),
  VocabWord(id: 'w_useum', korean: '웃음', english: 'laughter', category: WordCategory.emotion, imageSlot: 'img/word/useum', emoji: '😂'),
  VocabWord(id: 'w_maeum', korean: '마음', english: 'heart / mind', category: WordCategory.emotion, imageSlot: 'img/word/maeum', emoji: '💖'),
  VocabWord(id: 'w_kkum', korean: '꿈', english: 'dream', category: WordCategory.emotion, imageSlot: 'img/word/kkum', emoji: '🌙'),
  // --- Daily ---
  VocabWord(id: 'w_annyeong', korean: '안녕', english: 'hello / bye', category: WordCategory.daily, imageSlot: 'img/word/annyeong', emoji: '👋'),
  VocabWord(id: 'w_gamsa', korean: '감사', english: 'thanks', category: WordCategory.daily, imageSlot: 'img/word/gamsa', emoji: '🙏'),
  VocabWord(id: 'w_chingu', korean: '친구', english: 'friend', category: WordCategory.daily, imageSlot: 'img/word/chingu', emoji: '🧑‍🤝‍🧑'),
  VocabWord(id: 'w_jip', korean: '집', english: 'house', category: WordCategory.daily, imageSlot: 'img/word/jip', emoji: '🏠'),
  VocabWord(id: 'w_hakgyo', korean: '학교', english: 'school', category: WordCategory.daily, imageSlot: 'img/word/hakgyo', emoji: '🏫'),
  VocabWord(id: 'w_beoseu', korean: '버스', english: 'bus', category: WordCategory.daily, imageSlot: 'img/word/beoseu', emoji: '🚌'),
  VocabWord(id: 'w_jeonhwa', korean: '전화', english: 'phone call', category: WordCategory.daily, imageSlot: 'img/word/jeonhwa', emoji: '📞'),
  VocabWord(id: 'w_norae', korean: '노래', english: 'song', category: WordCategory.daily, imageSlot: 'img/word/norae', emoji: '🎵'),
  VocabWord(id: 'w_chum', korean: '춤', english: 'dance', category: WordCategory.daily, imageSlot: 'img/word/chum', emoji: '💃'),
  VocabWord(id: 'w_haneul', korean: '하늘', english: 'sky', category: WordCategory.daily, imageSlot: 'img/word/haneul', emoji: '🌤️'),
  VocabWord(id: 'w_bada', korean: '바다', english: 'sea', category: WordCategory.daily, imageSlot: 'img/word/bada', emoji: '🌊'),
  // --- K-culture (generic common nouns only) ---
  VocabWord(id: 'w_hanbok', korean: '한복', english: 'hanbok', category: WordCategory.kculture, imageSlot: 'img/word/hanbok', emoji: '👘'),
  VocabWord(id: 'w_deurama', korean: '드라마', english: 'drama', category: WordCategory.kculture, imageSlot: 'img/word/deurama', emoji: '📺'),
  VocabWord(id: 'w_yeonghwa', korean: '영화', english: 'movie', category: WordCategory.kculture, imageSlot: 'img/word/yeonghwa', emoji: '🎬'),
  VocabWord(id: 'w_gasu', korean: '가수', english: 'singer', category: WordCategory.kculture, imageSlot: 'img/word/gasu', emoji: '🎤'),
  VocabWord(id: 'w_baeu', korean: '배우', english: 'actor', category: WordCategory.kculture, imageSlot: 'img/word/baeu', emoji: '🎭'),
  VocabWord(id: 'w_eungwon', korean: '응원', english: 'cheering', category: WordCategory.kculture, imageSlot: 'img/word/eungwon', emoji: '📣'),
  VocabWord(id: 'w_mudae', korean: '무대', english: 'stage', category: WordCategory.kculture, imageSlot: 'img/word/mudae', emoji: '🎪'),
  VocabWord(id: 'w_paen', korean: '팬', english: 'fan', category: WordCategory.kculture, imageSlot: 'img/word/paen', emoji: '🫶'),
];

final Map<String, VocabWord> vocabById = {
  for (final w in vocabWords) w.id: w,
};
