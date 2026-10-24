/// "Explore Korea" — free culture & travel guide alongside the lessons:
/// travel apps, a short history timeline, must-try food (with live map
/// searches instead of hardcoded rankings, which go stale), and links to
/// our own saju readings. Pure data; rendered by features/explore.
library;

class TravelApp {
  const TravelApp({
    required this.name,
    required this.nameKo,
    required this.useFor,
    required this.tip,
    required this.url,
  });

  final String name;
  final String nameKo;
  final String useFor;
  final String tip;
  final String url;
}

class HistoryEra {
  const HistoryEra(this.era, this.eraKo, this.years, this.story);

  final String era;
  final String eraKo;
  final String years;
  final String story;
}

class FoodPick {
  const FoodPick({
    required this.dish,
    required this.dishKo,
    required this.why,
    required this.whereToTry,
    required this.searchKo,
  });

  final String dish;
  final String dishKo;
  final String why;
  final String whereToTry;

  /// Korean query for the live map searches (e.g. "삼겹살").
  final String searchKo;

  String get naverMapUrl =>
      'https://map.naver.com/p/search/${Uri.encodeComponent(searchKo)}';
  String get googleMapsUrl =>
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeQueryComponent(searchKo)}';
}

class ShopLink {
  const ShopLink(this.title, this.description, this.url);

  final String title;
  final String description;
  final String url;
}

const List<TravelApp> travelApps = [
  TravelApp(
    name: 'Naver Map',
    nameKo: '네이버 지도',
    useFor: 'Walking, subway and bus directions, opening hours and reviews.',
    tip: 'Google Maps cannot give full walking or driving directions in '
        'Korea — locals use Naver Map. Switch the app language to English '
        'in settings.',
    url: 'https://map.naver.com',
  ),
  TravelApp(
    name: 'Kakao Map',
    nameKo: '카카오맵',
    useFor: 'A second map app with great real-time bus arrival info.',
    tip: 'Handy for checking when your bus arrives at a stop.',
    url: 'https://map.kakao.com',
  ),
  TravelApp(
    name: 'KakaoMetro',
    nameKo: '카카오지하철',
    useFor: 'Subway route planner for Seoul, Busan, Daegu, Gwangju and '
        'Daejeon.',
    tip: 'It tells you which train car to board for the fastest transfer '
        'or exit. On Android, search "KakaoMetro" in Google Play.',
    url: 'https://apps.apple.com/app/id1095533900',
  ),
  TravelApp(
    name: 'Kakao T',
    nameKo: '카카오 T',
    useFor: 'Calling taxis — the way most people get a cab in Korea.',
    tip: 'Set your destination in the app so you do not need to explain '
        'it to the driver.',
    url: 'https://www.kakaomobility.com',
  ),
  TravelApp(
    name: 'Papago',
    nameKo: '파파고',
    useFor: 'Korean ↔ English translation, including camera mode for '
        'menus and signs.',
    tip: 'Point the camera at a menu to translate it instantly.',
    url: 'https://papago.naver.com',
  ),
  TravelApp(
    name: 'Korail (KTX trains)',
    nameKo: '코레일',
    useFor: 'Booking high-speed KTX trains between cities.',
    tip: 'Seoul → Busan takes about 2.5 hours by KTX. Book ahead on '
        'weekends and holidays.',
    url: 'https://www.letskorail.com',
  ),
  TravelApp(
    name: 'VisitKorea',
    nameKo: '대한민국 구석구석',
    useFor: 'Official tourism guide: events, attractions and travel info.',
    tip: 'Call 1330 any time for free tourist help with interpreters.',
    url: 'https://english.visitkorea.or.kr',
  ),
];

const List<HistoryEra> koreanHistory = [
  HistoryEra(
      'Gojoseon',
      '고조선',
      'legend: 2333 BC',
      'The first Korean kingdom. Its founding by Dangun is celebrated every '
          '3 October as National Foundation Day (개천절).'),
  HistoryEra(
      'Three Kingdoms',
      '삼국 시대',
      '1st c. BC – 668',
      'Goguryeo in the north, Baekje in the southwest and Silla in the '
          'southeast competed for the peninsula, and Buddhism spread widely.'),
  HistoryEra(
      'Unified Silla',
      '통일 신라',
      '668 – 935',
      'Silla unified most of the peninsula. Its capital Gyeongju left '
          'treasures like Bulguksa Temple and Seokguram Grotto.'),
  HistoryEra(
      'Goryeo',
      '고려',
      '918 – 1392',
      'The name "Korea" comes from Goryeo. Famous for celadon pottery and '
          "some of the world's earliest metal movable type."),
  HistoryEra(
      'Joseon',
      '조선',
      '1392 – 1897',
      'A Confucian dynasty ruled from Seoul. King Sejong created Hangul in '
          '1443 and announced it in 1446 — celebrated on Hangul Day, 9 October.'),
  HistoryEra(
      'Korean Empire',
      '대한제국',
      '1897 – 1910',
      'Joseon became an empire and tried to modernise under growing '
          'foreign pressure.'),
  HistoryEra(
      'Japanese colonial rule',
      '일제 강점기',
      '1910 – 1945',
      'Korea was annexed by Japan. The 1 March 1919 independence movement '
          '(삼일절) is remembered as a national holiday.'),
  HistoryEra(
      'Liberation & division',
      '광복과 분단',
      '1945 – 1953',
      'Liberated in 1945 (광복절, 15 August), the peninsula was divided. '
          'The Korean War (1950–1953) ended in an armistice, not a peace treaty.'),
  HistoryEra(
      'Rapid growth',
      '한강의 기적',
      '1960s – 1980s',
      'Industrialisation turned South Korea from one of the poorest '
          'countries into a major economy — the "Miracle on the Han River".'),
  HistoryEra(
      'Democracy & the world stage',
      '민주화와 올림픽',
      '1987 – 1990s',
      'Mass protests won democratic elections in 1987, and Seoul hosted '
          'the 1988 Summer Olympics.'),
  HistoryEra(
      'Hallyu — the Korean Wave',
      '한류',
      '2000s – today',
      'Korean dramas, music, films, food and beauty spread worldwide — '
          'which may be why you are learning Hangul right now!'),
];

const List<FoodPick> foodPicks = [
  FoodPick(
    dish: 'Korean BBQ (pork belly)',
    dishKo: '삼겹살',
    why: 'Grilled at your table, wrapped in lettuce with garlic and sauce.',
    whereToTry: 'Barbecue alleys everywhere — Mapo in Seoul is famous.',
    searchKo: '삼겹살',
  ),
  FoodPick(
    dish: 'Bibimbap',
    dishKo: '비빔밥',
    why: 'Rice topped with vegetables, egg and chili paste — mix it all.',
    whereToTry: 'Jeonju is the bibimbap capital of Korea.',
    searchKo: '비빔밥',
  ),
  FoodPick(
    dish: 'Mung bean pancake',
    dishKo: '빈대떡',
    why: 'Crispy fried pancakes, best with makgeolli rice wine.',
    whereToTry: 'Gwangjang Market in Seoul, also known for mini gimbap.',
    searchKo: '광장시장 빈대떡',
  ),
  FoodPick(
    dish: 'Tteokbokki',
    dishKo: '떡볶이',
    why: 'Chewy rice cakes in sweet-spicy sauce — the classic street snack.',
    whereToTry: 'Sindang-dong in Seoul has a whole tteokbokki street.',
    searchKo: '떡볶이',
  ),
  FoodPick(
    dish: 'Spicy stir-fried chicken',
    dishKo: '닭갈비',
    why: 'Chicken, cabbage and rice cakes stir-fried in a big pan.',
    whereToTry: 'Chuncheon is famous for it.',
    searchKo: '닭갈비',
  ),
  FoodPick(
    dish: 'Pork and rice soup',
    dishKo: '돼지국밥',
    why: 'Hearty pork broth over rice — a local favourite.',
    whereToTry: 'Busan is the home of dwaeji gukbap.',
    searchKo: '부산 돼지국밥',
  ),
  FoodPick(
    dish: 'Ginseng chicken soup',
    dishKo: '삼계탕',
    why: 'A whole young chicken stuffed with rice and ginseng.',
    whereToTry: 'Koreans eat it on the hottest summer days for energy.',
    searchKo: '삼계탕',
  ),
  FoodPick(
    dish: 'Cold buckwheat noodles',
    dishKo: '냉면',
    why: 'Chewy noodles in icy broth — refreshing in summer.',
    whereToTry: 'Found at naengmyeon specialists and BBQ restaurants.',
    searchKo: '냉면',
  ),
  FoodPick(
    dish: 'Jeju black pork',
    dishKo: '흑돼지',
    why: 'A famous local breed, grilled like Korean BBQ.',
    whereToTry: 'Jeju Island.',
    searchKo: '제주 흑돼지',
  ),
];

/// Our own saju (Korean four pillars) readings on Etsy. Web only: store
/// builds must not link to outside purchases of digital services.
const List<ShopLink> sajuLinks = [
  ShopLink(
    'Korean Saju reading',
    'Your Four Pillars of Destiny read from your birth date and time — '
        'personality, strengths and the year ahead.',
    'https://www.etsy.com/listing/4595217652/korean-saju-reading-four-pillars-birth',
  ),
  ShopLink(
    'Saju couple compatibility',
    'How your two birth charts match — love, communication and harmony '
        'through Korean saju (궁합).',
    'https://www.etsy.com/listing/4595141741/korean-saju-couple-compatibility-reading',
  ),
];
