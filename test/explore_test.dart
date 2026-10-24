import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/core/data/explore.dart';

import 'widget_smoke_test.dart' show pumpApp, settleRoute;

void main() {
  test('every external link is https', () {
    final urls = [
      for (final a in travelApps) a.url,
      for (final f in foodPicks) ...[f.naverMapUrl, f.googleMapsUrl],
      for (final s in sajuLinks) s.url,
    ];
    for (final u in urls) {
      final uri = Uri.parse(u);
      expect(uri.scheme, 'https', reason: u);
      expect(uri.host, isNotEmpty, reason: u);
    }
  });

  test('map searches encode the Korean query', () {
    const f = FoodPick(
        dish: 'x', dishKo: 'x', why: 'x', whereToTry: 'x', searchKo: '삼겹살');
    expect(Uri.parse(f.googleMapsUrl).queryParameters['query'], '삼겹살');
    expect(f.naverMapUrl, endsWith('/search/${Uri.encodeComponent('삼겹살')}'));
  });

  test('history runs in chronological order and ends with Hallyu', () {
    expect(koreanHistory.first.era, 'Gojoseon');
    expect(koreanHistory.last.eraKo, '한류');
  });

  testWidgets('home → Explore Korea shows apps, history and food tabs',
      (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Explore Korea · 한국 둘러보기'));
    await settleRoute(tester);
    expect(find.textContaining('Naver Map'), findsWidgets);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Joseon'), findsWidgets);

    await tester.tap(find.text('Food'));
    await tester.pumpAndSettle();
    expect(find.textContaining('삼겹살'), findsWidgets);

    // Tests run as a non-web build: the store-safe tab set has no saju tab.
    expect(find.text('Saju'), findsNothing);
  });
}
