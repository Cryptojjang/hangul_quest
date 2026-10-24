import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/core/data/lessons.dart';
import 'package:hangul_quest/core/hangul/hangul.dart';

import 'widget_smoke_test.dart' show pumpApp, settleRoute;

void main() {
  final taught = <String>{
    for (final l in hangulCourse)
      for (final b in l.blocks)
        if (b is LessonJamo) ...b.ids,
  };

  test('every jamo referenced by a lesson exists and has an English tip', () {
    for (final id in taught) {
      expect(jamoById[id], isNotNull, reason: id);
      expect(jamoTipsEn[id], isNotNull, reason: id);
    }
  });

  test('course teaches all 19 initial consonants and all 21 vowels', () {
    for (final j in [...choseongTable, ...jungseongTable]) {
      expect(taught, contains(j.id), reason: '${j.char} not taught');
    }
  });

  test('romanization matches Revised Romanization for common syllables', () {
    String r(String s) => romanizeSyllable(decompose(s.runes.first));
    expect(r('가'), 'ga');
    expect(r('한'), 'han');
    expect(r('글'), 'geul');
    expect(r('강'), 'gang');
    expect(r('과'), 'gwa');
    expect(r('아'), 'a'); // silent ㅇ
    expect(r('옷'), 'ot'); // ㅅ final → t
    expect(r('앞'), 'ap'); // ㅍ final → p
    expect(r('닭'), 'dak'); // ㄺ final → k
  });

  test('lesson ids are unique', () {
    final ids = hangulCourse.map((l) => l.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  testWidgets('home → Learn → lessons render, builder composes',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Learn Hangul · 한글 배우기'));
    await tester.pumpAndSettle();
    expect(find.textContaining('What is Hangul?'), findsOneWidget);

    // Every lesson builds without layout errors.
    for (var i = 0; i < hangulCourse.length; i++) {
      await tester.tap(find.textContaining(hangulCourse[i].title).first);
      await settleRoute(tester);
      expect(tester.takeException(), isNull, reason: hangulCourse[i].id);
      await tester.pageBack();
      await settleRoute(tester);
    }

    // Syllable builder: ㄱ+ㅏ → 가, then pick final ㅇ → 강.
    await tester.tap(find.textContaining('Build a syllable').first);
    await settleRoute(tester);
    expect(find.text('[ga]'), findsOneWidget);
    // The list builds lazily: scroll the finals picker into existence first.
    await tester.scrollUntilVisible(
        find.text('3. Final consonant (optional)'), 300);
    await tester.pump();
    final finalNg = find.text('ㅇ').last; // finals picker is last
    await tester.ensureVisible(finalNg);
    await tester.tap(finalNg);
    await tester.pump();
    expect(find.text('[gang]'), findsOneWidget);
  });
}
