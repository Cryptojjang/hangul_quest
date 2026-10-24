/// Word Rush vocabulary dataset.
///
/// Content policy (spec §3.1): everyday + K-culture COMMON NOUNS only.
/// No trademarked proper nouns (group names, artist names, show titles) and
/// no song lyrics — reviewed against the checklist in docs/PRODUCT_SPEC.md.
library;

enum WordCategory {
  food,
  emotion,
  daily,
  kculture,
  animal,
  nature,
  place,
  transport,
  body,
  people,
  thing,
}

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
  // --- Snacks & sweets ---
  VocabWord(id: 'w_tteokbokki', korean: '떡볶이', english: 'spicy rice cakes', category: WordCategory.food, imageSlot: 'img/word/tteokbokki', emoji: '🌶️'),
  VocabWord(id: 'w_mandu', korean: '만두', english: 'dumplings', category: WordCategory.food, imageSlot: 'img/word/mandu', emoji: '🥟'),
  VocabWord(id: 'w_ppang', korean: '빵', english: 'bread', category: WordCategory.food, imageSlot: 'img/word/ppang', emoji: '🍞'),
  VocabWord(id: 'w_gyeran', korean: '계란', english: 'egg', category: WordCategory.food, imageSlot: 'img/word/gyeran', emoji: '🥚'),
  VocabWord(id: 'w_aiseukeurim', korean: '아이스크림', english: 'ice cream', category: WordCategory.food, imageSlot: 'img/word/aiseukeurim', emoji: '🍦'),
  VocabWord(id: 'w_keikeu', korean: '케이크', english: 'cake', category: WordCategory.food, imageSlot: 'img/word/keikeu', emoji: '🍰'),
  VocabWord(id: 'w_satang', korean: '사탕', english: 'candy', category: WordCategory.food, imageSlot: 'img/word/satang', emoji: '🍬'),
  VocabWord(id: 'w_chokollit', korean: '초콜릿', english: 'chocolate', category: WordCategory.food, imageSlot: 'img/word/chokollit', emoji: '🍫'),
  // --- Fruit & vegetables ---
  VocabWord(id: 'w_subak', korean: '수박', english: 'watermelon', category: WordCategory.food, imageSlot: 'img/word/subak', emoji: '🍉'),
  VocabWord(id: 'w_ttalgi', korean: '딸기', english: 'strawberry', category: WordCategory.food, imageSlot: 'img/word/ttalgi', emoji: '🍓'),
  VocabWord(id: 'w_banana', korean: '바나나', english: 'banana', category: WordCategory.food, imageSlot: 'img/word/banana', emoji: '🍌'),
  VocabWord(id: 'w_podo', korean: '포도', english: 'grapes', category: WordCategory.food, imageSlot: 'img/word/podo', emoji: '🍇'),
  VocabWord(id: 'w_oksusu', korean: '옥수수', english: 'corn', category: WordCategory.food, imageSlot: 'img/word/oksusu', emoji: '🌽'),
  VocabWord(id: 'w_gamja', korean: '감자', english: 'potato', category: WordCategory.food, imageSlot: 'img/word/gamja', emoji: '🥔'),
  VocabWord(id: 'w_danggeun', korean: '당근', english: 'carrot', category: WordCategory.food, imageSlot: 'img/word/danggeun', emoji: '🥕'),
  // --- Drinks & dining ---
  VocabWord(id: 'w_juseu', korean: '주스', english: 'juice', category: WordCategory.food, imageSlot: 'img/word/juseu', emoji: '🧃'),
  VocabWord(id: 'w_cha', korean: '차', english: 'tea', category: WordCategory.food, imageSlot: 'img/word/cha', emoji: '🍵'),
  VocabWord(id: 'w_maekju', korean: '맥주', english: 'beer', category: WordCategory.food, imageSlot: 'img/word/maekju', emoji: '🍺'),
  VocabWord(id: 'w_soju', korean: '소주', english: 'soju', category: WordCategory.food, imageSlot: 'img/word/soju', emoji: '🍶'),
  VocabWord(id: 'w_pija', korean: '피자', english: 'pizza', category: WordCategory.food, imageSlot: 'img/word/pija', emoji: '🍕'),
  VocabWord(id: 'w_haembeogeo', korean: '햄버거', english: 'hamburger', category: WordCategory.food, imageSlot: 'img/word/haembeogeo', emoji: '🍔'),
  VocabWord(id: 'w_samgyeopsal', korean: '삼겹살', english: 'pork belly', category: WordCategory.food, imageSlot: 'img/word/samgyeopsal', emoji: '🥓'),
  VocabWord(id: 'w_saengseon', korean: '생선', english: 'fish (food)', category: WordCategory.food, imageSlot: 'img/word/saengseon', emoji: '🐟'),
  // --- Pets & farm animals ---
  VocabWord(id: 'w_goyangi', korean: '고양이', english: 'cat', category: WordCategory.animal, imageSlot: 'img/word/goyangi', emoji: '🐱'),
  VocabWord(id: 'w_gangaji', korean: '강아지', english: 'puppy', category: WordCategory.animal, imageSlot: 'img/word/gangaji', emoji: '🐶'),
  VocabWord(id: 'w_tokki', korean: '토끼', english: 'rabbit', category: WordCategory.animal, imageSlot: 'img/word/tokki', emoji: '🐰'),
  VocabWord(id: 'w_dwaeji', korean: '돼지', english: 'pig', category: WordCategory.animal, imageSlot: 'img/word/dwaeji', emoji: '🐷'),
  VocabWord(id: 'w_so', korean: '소', english: 'cow', category: WordCategory.animal, imageSlot: 'img/word/so', emoji: '🐮'),
  VocabWord(id: 'w_dak', korean: '닭', english: 'chicken (animal)', category: WordCategory.animal, imageSlot: 'img/word/dak', emoji: '🐔'),
  VocabWord(id: 'w_ori', korean: '오리', english: 'duck', category: WordCategory.animal, imageSlot: 'img/word/ori', emoji: '🦆'),
  VocabWord(id: 'w_mal', korean: '말', english: 'horse', category: WordCategory.animal, imageSlot: 'img/word/mal', emoji: '🐴'),
  VocabWord(id: 'w_yang', korean: '양', english: 'sheep', category: WordCategory.animal, imageSlot: 'img/word/yang', emoji: '🐑'),
  // --- Wild animals ---
  VocabWord(id: 'w_gom', korean: '곰', english: 'bear', category: WordCategory.animal, imageSlot: 'img/word/gom', emoji: '🐻'),
  VocabWord(id: 'w_horangi', korean: '호랑이', english: 'tiger', category: WordCategory.animal, imageSlot: 'img/word/horangi', emoji: '🐯'),
  VocabWord(id: 'w_saja', korean: '사자', english: 'lion', category: WordCategory.animal, imageSlot: 'img/word/saja', emoji: '🦁'),
  VocabWord(id: 'w_wonsungi', korean: '원숭이', english: 'monkey', category: WordCategory.animal, imageSlot: 'img/word/wonsungi', emoji: '🐒'),
  VocabWord(id: 'w_kokkiri', korean: '코끼리', english: 'elephant', category: WordCategory.animal, imageSlot: 'img/word/kokkiri', emoji: '🐘'),
  VocabWord(id: 'w_panda', korean: '판다', english: 'panda', category: WordCategory.animal, imageSlot: 'img/word/panda', emoji: '🐼'),
  VocabWord(id: 'w_baem', korean: '뱀', english: 'snake', category: WordCategory.animal, imageSlot: 'img/word/baem', emoji: '🐍'),
  // --- Small creatures ---
  VocabWord(id: 'w_sae', korean: '새', english: 'bird', category: WordCategory.animal, imageSlot: 'img/word/sae', emoji: '🐦'),
  VocabWord(id: 'w_mulgogi', korean: '물고기', english: 'fish', category: WordCategory.animal, imageSlot: 'img/word/mulgogi', emoji: '🐠'),
  VocabWord(id: 'w_nabi', korean: '나비', english: 'butterfly', category: WordCategory.animal, imageSlot: 'img/word/nabi', emoji: '🦋'),
  VocabWord(id: 'w_geobugi', korean: '거북이', english: 'turtle', category: WordCategory.animal, imageSlot: 'img/word/geobugi', emoji: '🐢'),
  VocabWord(id: 'w_beol', korean: '벌', english: 'bee', category: WordCategory.animal, imageSlot: 'img/word/beol', emoji: '🐝'),
  VocabWord(id: 'w_gaemi', korean: '개미', english: 'ant', category: WordCategory.animal, imageSlot: 'img/word/gaemi', emoji: '🐜'),
  // --- Sky & weather ---
  VocabWord(id: 'w_hae', korean: '해', english: 'sun', category: WordCategory.nature, imageSlot: 'img/word/hae', emoji: '☀️'),
  VocabWord(id: 'w_dal', korean: '달', english: 'moon', category: WordCategory.nature, imageSlot: 'img/word/dal', emoji: '🌕'),
  VocabWord(id: 'w_byeol', korean: '별', english: 'star', category: WordCategory.nature, imageSlot: 'img/word/byeol', emoji: '⭐'),
  VocabWord(id: 'w_bi', korean: '비', english: 'rain', category: WordCategory.nature, imageSlot: 'img/word/bi', emoji: '🌧️'),
  VocabWord(id: 'w_nun', korean: '눈', english: 'snow', category: WordCategory.nature, imageSlot: 'img/word/nun', emoji: '❄️'),
  VocabWord(id: 'w_gureum', korean: '구름', english: 'cloud', category: WordCategory.nature, imageSlot: 'img/word/gureum', emoji: '☁️'),
  VocabWord(id: 'w_baram', korean: '바람', english: 'wind', category: WordCategory.nature, imageSlot: 'img/word/baram', emoji: '🌬️'),
  VocabWord(id: 'w_mujigae', korean: '무지개', english: 'rainbow', category: WordCategory.nature, imageSlot: 'img/word/mujigae', emoji: '🌈'),
  // --- Nature ---
  VocabWord(id: 'w_san', korean: '산', english: 'mountain', category: WordCategory.nature, imageSlot: 'img/word/san', emoji: '⛰️'),
  VocabWord(id: 'w_kkot', korean: '꽃', english: 'flower', category: WordCategory.nature, imageSlot: 'img/word/kkot', emoji: '🌸'),
  VocabWord(id: 'w_namu', korean: '나무', english: 'tree', category: WordCategory.nature, imageSlot: 'img/word/namu', emoji: '🌳'),
  VocabWord(id: 'w_bul', korean: '불', english: 'fire', category: WordCategory.nature, imageSlot: 'img/word/bul', emoji: '🔥'),
  VocabWord(id: 'w_gang', korean: '강', english: 'river', category: WordCategory.nature, imageSlot: 'img/word/gang', emoji: '🏞️'),
  VocabWord(id: 'w_seom', korean: '섬', english: 'island', category: WordCategory.nature, imageSlot: 'img/word/seom', emoji: '🏝️'),
  VocabWord(id: 'w_dol', korean: '돌', english: 'stone', category: WordCategory.nature, imageSlot: 'img/word/dol', emoji: '🪨'),
  // --- Around town ---
  VocabWord(id: 'w_byeongwon', korean: '병원', english: 'hospital', category: WordCategory.place, imageSlot: 'img/word/byeongwon', emoji: '🏥'),
  VocabWord(id: 'w_eunhaeng', korean: '은행', english: 'bank', category: WordCategory.place, imageSlot: 'img/word/eunhaeng', emoji: '🏦'),
  VocabWord(id: 'w_pyeonuijeom', korean: '편의점', english: 'convenience store', category: WordCategory.place, imageSlot: 'img/word/pyeonuijeom', emoji: '🏪'),
  VocabWord(id: 'w_sikdang', korean: '식당', english: 'restaurant', category: WordCategory.place, imageSlot: 'img/word/sikdang', emoji: '🍽️'),
  VocabWord(id: 'w_kape', korean: '카페', english: 'café', category: WordCategory.place, imageSlot: 'img/word/kape', emoji: '🧋'),
  VocabWord(id: 'w_doseogwan', korean: '도서관', english: 'library', category: WordCategory.place, imageSlot: 'img/word/doseogwan', emoji: '📚'),
  VocabWord(id: 'w_gongwon', korean: '공원', english: 'park', category: WordCategory.place, imageSlot: 'img/word/gongwon', emoji: '🌲'),
  // --- Places to visit ---
  VocabWord(id: 'w_gonghang', korean: '공항', english: 'airport', category: WordCategory.place, imageSlot: 'img/word/gonghang', emoji: '🛫'),
  VocabWord(id: 'w_hotel', korean: '호텔', english: 'hotel', category: WordCategory.place, imageSlot: 'img/word/hotel', emoji: '🏨'),
  VocabWord(id: 'w_jeol', korean: '절', english: 'temple', category: WordCategory.place, imageSlot: 'img/word/jeol', emoji: '🛕'),
  VocabWord(id: 'w_sijang', korean: '시장', english: 'market', category: WordCategory.place, imageSlot: 'img/word/sijang', emoji: '🛒'),
  VocabWord(id: 'w_hwajangsil', korean: '화장실', english: 'restroom', category: WordCategory.place, imageSlot: 'img/word/hwajangsil', emoji: '🚻'),
  VocabWord(id: 'w_ucheguk', korean: '우체국', english: 'post office', category: WordCategory.place, imageSlot: 'img/word/ucheguk', emoji: '📮'),
  VocabWord(id: 'w_gyeongchalseo', korean: '경찰서', english: 'police station', category: WordCategory.place, imageSlot: 'img/word/gyeongchalseo', emoji: '🚓'),
  // --- Getting around ---
  VocabWord(id: 'w_taeksi', korean: '택시', english: 'taxi', category: WordCategory.transport, imageSlot: 'img/word/taeksi', emoji: '🚕'),
  VocabWord(id: 'w_jihacheol', korean: '지하철', english: 'subway', category: WordCategory.transport, imageSlot: 'img/word/jihacheol', emoji: '🚇'),
  VocabWord(id: 'w_gicha', korean: '기차', english: 'train', category: WordCategory.transport, imageSlot: 'img/word/gicha', emoji: '🚆'),
  VocabWord(id: 'w_bihaenggi', korean: '비행기', english: 'airplane', category: WordCategory.transport, imageSlot: 'img/word/bihaenggi', emoji: '✈️'),
  VocabWord(id: 'w_jajeongeo', korean: '자전거', english: 'bicycle', category: WordCategory.transport, imageSlot: 'img/word/jajeongeo', emoji: '🚲'),
  VocabWord(id: 'w_bae', korean: '배', english: 'ship', category: WordCategory.transport, imageSlot: 'img/word/bae', emoji: '🚢'),
  VocabWord(id: 'w_jadongcha', korean: '자동차', english: 'car', category: WordCategory.transport, imageSlot: 'img/word/jadongcha', emoji: '🚗'),
  VocabWord(id: 'w_otobai', korean: '오토바이', english: 'motorcycle', category: WordCategory.transport, imageSlot: 'img/word/otobai', emoji: '🏍️'),
  // --- My body ---
  VocabWord(id: 'w_son', korean: '손', english: 'hand', category: WordCategory.body, imageSlot: 'img/word/son', emoji: '✋'),
  VocabWord(id: 'w_bal', korean: '발', english: 'foot', category: WordCategory.body, imageSlot: 'img/word/bal', emoji: '🦶'),
  VocabWord(id: 'w_gwi', korean: '귀', english: 'ear', category: WordCategory.body, imageSlot: 'img/word/gwi', emoji: '👂'),
  VocabWord(id: 'w_ko', korean: '코', english: 'nose', category: WordCategory.body, imageSlot: 'img/word/ko', emoji: '👃'),
  VocabWord(id: 'w_ip', korean: '입', english: 'mouth', category: WordCategory.body, imageSlot: 'img/word/ip', emoji: '👄'),
  VocabWord(id: 'w_eolgul', korean: '얼굴', english: 'face', category: WordCategory.body, imageSlot: 'img/word/eolgul', emoji: '🙂'),
  VocabWord(id: 'w_i_tooth', korean: '이', english: 'tooth', category: WordCategory.body, imageSlot: 'img/word/i_tooth', emoji: '🦷'),
  // --- Family ---
  VocabWord(id: 'w_eomma', korean: '엄마', english: 'mom', category: WordCategory.people, imageSlot: 'img/word/eomma', emoji: '👩'),
  VocabWord(id: 'w_appa', korean: '아빠', english: 'dad', category: WordCategory.people, imageSlot: 'img/word/appa', emoji: '👨'),
  VocabWord(id: 'w_agi', korean: '아기', english: 'baby', category: WordCategory.people, imageSlot: 'img/word/agi', emoji: '👶'),
  VocabWord(id: 'w_halmeoni', korean: '할머니', english: 'grandma', category: WordCategory.people, imageSlot: 'img/word/halmeoni', emoji: '👵'),
  VocabWord(id: 'w_harabeoji', korean: '할아버지', english: 'grandpa', category: WordCategory.people, imageSlot: 'img/word/harabeoji', emoji: '👴'),
  VocabWord(id: 'w_oppa', korean: '오빠', english: 'older brother (said by a girl)', category: WordCategory.people, imageSlot: 'img/word/oppa', emoji: '🙋‍♂️'),
  VocabWord(id: 'w_eonni', korean: '언니', english: 'older sister (said by a girl)', category: WordCategory.people, imageSlot: 'img/word/eonni', emoji: '🙋‍♀️'),
  // --- People at work ---
  VocabWord(id: 'w_seonsaengnim', korean: '선생님', english: 'teacher', category: WordCategory.people, imageSlot: 'img/word/seonsaengnim', emoji: '🧑‍🏫'),
  VocabWord(id: 'w_uisa', korean: '의사', english: 'doctor', category: WordCategory.people, imageSlot: 'img/word/uisa', emoji: '🧑‍⚕️'),
  VocabWord(id: 'w_haksaeng', korean: '학생', english: 'student', category: WordCategory.people, imageSlot: 'img/word/haksaeng', emoji: '🧑‍🎓'),
  VocabWord(id: 'w_gyeongchal', korean: '경찰', english: 'police officer', category: WordCategory.people, imageSlot: 'img/word/gyeongchal', emoji: '👮'),
  VocabWord(id: 'w_yorisa', korean: '요리사', english: 'chef', category: WordCategory.people, imageSlot: 'img/word/yorisa', emoji: '🧑‍🍳'),
  VocabWord(id: 'w_hoesawon', korean: '회사원', english: 'office worker', category: WordCategory.people, imageSlot: 'img/word/hoesawon', emoji: '🧑‍💼'),
  // --- Things I carry ---
  VocabWord(id: 'w_chaek', korean: '책', english: 'book', category: WordCategory.thing, imageSlot: 'img/word/chaek', emoji: '📖'),
  VocabWord(id: 'w_gabang', korean: '가방', english: 'bag', category: WordCategory.thing, imageSlot: 'img/word/gabang', emoji: '👜'),
  VocabWord(id: 'w_sigye', korean: '시계', english: 'clock', category: WordCategory.thing, imageSlot: 'img/word/sigye', emoji: '⏰'),
  VocabWord(id: 'w_usan', korean: '우산', english: 'umbrella', category: WordCategory.thing, imageSlot: 'img/word/usan', emoji: '☂️'),
  VocabWord(id: 'w_moja', korean: '모자', english: 'hat', category: WordCategory.thing, imageSlot: 'img/word/moja', emoji: '🧢'),
  VocabWord(id: 'w_sinbal', korean: '신발', english: 'shoes', category: WordCategory.thing, imageSlot: 'img/word/sinbal', emoji: '👟'),
  VocabWord(id: 'w_ot', korean: '옷', english: 'clothes', category: WordCategory.thing, imageSlot: 'img/word/ot', emoji: '👕'),
  VocabWord(id: 'w_angyeong', korean: '안경', english: 'glasses', category: WordCategory.thing, imageSlot: 'img/word/angyeong', emoji: '👓'),
  // --- Things at home ---
  VocabWord(id: 'w_yeolsoe', korean: '열쇠', english: 'key', category: WordCategory.thing, imageSlot: 'img/word/yeolsoe', emoji: '🔑'),
  VocabWord(id: 'w_keompyuteo', korean: '컴퓨터', english: 'computer', category: WordCategory.thing, imageSlot: 'img/word/keompyuteo', emoji: '💻'),
  VocabWord(id: 'w_sajin', korean: '사진', english: 'photo', category: WordCategory.thing, imageSlot: 'img/word/sajin', emoji: '📷'),
  VocabWord(id: 'w_don', korean: '돈', english: 'money', category: WordCategory.thing, imageSlot: 'img/word/don', emoji: '💵'),
  VocabWord(id: 'w_pyeonji', korean: '편지', english: 'letter', category: WordCategory.thing, imageSlot: 'img/word/pyeonji', emoji: '✉️'),
  VocabWord(id: 'w_seonmul', korean: '선물', english: 'gift', category: WordCategory.thing, imageSlot: 'img/word/seonmul', emoji: '🎁'),
  VocabWord(id: 'w_haendeupon', korean: '핸드폰', english: 'mobile phone', category: WordCategory.thing, imageSlot: 'img/word/haendeupon', emoji: '📱'),
  // --- Around the room ---
  VocabWord(id: 'w_uija', korean: '의자', english: 'chair', category: WordCategory.thing, imageSlot: 'img/word/uija', emoji: '🪑'),
  VocabWord(id: 'w_chimdae', korean: '침대', english: 'bed', category: WordCategory.thing, imageSlot: 'img/word/chimdae', emoji: '🛏️'),
  VocabWord(id: 'w_mun', korean: '문', english: 'door', category: WordCategory.thing, imageSlot: 'img/word/mun', emoji: '🚪'),
  VocabWord(id: 'w_yeonpil', korean: '연필', english: 'pencil', category: WordCategory.thing, imageSlot: 'img/word/yeonpil', emoji: '✏️'),
  VocabWord(id: 'w_gong', korean: '공', english: 'ball', category: WordCategory.thing, imageSlot: 'img/word/gong', emoji: '⚽'),
  VocabWord(id: 'w_changmun', korean: '창문', english: 'window', category: WordCategory.thing, imageSlot: 'img/word/changmun', emoji: '🪟'),
  // --- Fun Korean words ---
  VocabWord(id: 'w_hwaiting', korean: '화이팅', english: '"You can do it!"', category: WordCategory.kculture, imageSlot: 'img/word/hwaiting', emoji: '💪'),
  VocabWord(id: 'w_daebak', korean: '대박', english: 'awesome!', category: WordCategory.kculture, imageSlot: 'img/word/daebak', emoji: '🤩'),
  VocabWord(id: 'w_noraebang', korean: '노래방', english: 'karaoke room', category: WordCategory.kculture, imageSlot: 'img/word/noraebang', emoji: '🎙️'),
  VocabWord(id: 'w_hangeul', korean: '한글', english: 'Hangul (Korean alphabet)', category: WordCategory.kculture, imageSlot: 'img/word/hangeul', emoji: '🔤'),
  VocabWord(id: 'w_saengil', korean: '생일', english: 'birthday', category: WordCategory.kculture, imageSlot: 'img/word/saengil', emoji: '🎂'),
  VocabWord(id: 'w_chukha', korean: '축하', english: 'congratulations', category: WordCategory.kculture, imageSlot: 'img/word/chukha', emoji: '🎉'),
  // --- Free time ---
  VocabWord(id: 'w_yeohaeng', korean: '여행', english: 'travel', category: WordCategory.daily, imageSlot: 'img/word/yeohaeng', emoji: '🧳'),
  VocabWord(id: 'w_geim', korean: '게임', english: 'game', category: WordCategory.daily, imageSlot: 'img/word/geim', emoji: '🎮'),
  VocabWord(id: 'w_undong', korean: '운동', english: 'exercise', category: WordCategory.daily, imageSlot: 'img/word/undong', emoji: '🏋️'),
  VocabWord(id: 'w_gongbu', korean: '공부', english: 'study', category: WordCategory.daily, imageSlot: 'img/word/gongbu', emoji: '📝'),
  VocabWord(id: 'w_syoping', korean: '쇼핑', english: 'shopping', category: WordCategory.daily, imageSlot: 'img/word/syoping', emoji: '🛍️'),
  VocabWord(id: 'w_keopeul', korean: '커플', english: 'couple', category: WordCategory.daily, imageSlot: 'img/word/keopeul', emoji: '💑'),
];

final Map<String, VocabWord> vocabById = {
  for (final w in vocabWords) w.id: w,
};
