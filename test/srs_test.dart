import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/core/srs/srs.dart';

void main() {
  late DateTime now;
  late SrsScheduler srs;

  setUp(() {
    now = DateTime(2026, 7, 17, 9);
    srs = SrsScheduler(clock: () => now);
  });

  test('interval ladder: 1 → 3 → easiness-multiplied', () {
    expect(srs.review('c_giyeok', ReviewGrade.good), 1);
    expect(srs.review('c_giyeok', ReviewGrade.good), 3);
    final third = srs.review('c_giyeok', ReviewGrade.good);
    expect(third, greaterThan(3));
    final fourth = srs.review('c_giyeok', ReviewGrade.good);
    expect(fourth, greaterThan(third));
  });

  test('lapse resets repetitions and schedules relearn in 10 minutes', () {
    srs.review('v_a', ReviewGrade.good);
    srs.review('v_a', ReviewGrade.good);
    srs.review('v_a', ReviewGrade.again);
    final card = srs.cardFor('v_a');
    expect(card.repetitions, 0);
    expect(card.lapses, 1);
    expect(card.dueAt, now.add(const Duration(minutes: 10)));
    // relearn climbs the ladder again from 1 day
    expect(srs.review('v_a', ReviewGrade.good), 1);
  });

  test('easiness stays within [1.3, 2.8]', () {
    for (var i = 0; i < 30; i++) {
      srs.review('x', ReviewGrade.again);
    }
    expect(srs.cardFor('x').easiness, greaterThanOrEqualTo(1.3));
    for (var i = 0; i < 50; i++) {
      srs.review('y', ReviewGrade.easy);
    }
    expect(srs.cardFor('y').easiness, lessThanOrEqualTo(2.8));
  });

  test('dueCards: due items surface, future items do not', () {
    srs.review('a', ReviewGrade.good); // due tomorrow
    srs.review('b', ReviewGrade.again); // due in 10 min
    expect(srs.dueCards(), isEmpty);

    now = now.add(const Duration(minutes: 11));
    expect(srs.dueCards().map((c) => c.itemId), ['b']);

    now = now.add(const Duration(days: 1));
    expect(srs.dueCards().map((c) => c.itemId), containsAll(['a', 'b']));
  });

  test('buildSession: due first, then weak, then fallback pool; no dupes',
      () {
    srs.review('weak1', ReviewGrade.again);
    srs.review('weak2', ReviewGrade.again);
    now = now.add(const Duration(minutes: 30)); // both due
    final session = srs.buildSession(
        size: 5, fallbackPool: ['f1', 'f2', 'f3', 'weak1']);
    expect(session.length, 5);
    expect(session.toSet().length, 5, reason: 'no duplicates');
    expect(session.sublist(0, 2), containsAll(['weak1', 'weak2']));
    expect(session, containsAll(['f1', 'f2', 'f3']));
  });

  test('serialization roundtrip preserves scheduling', () {
    srs.review('a', ReviewGrade.good);
    srs.review('a', ReviewGrade.good);
    srs.review('b', ReviewGrade.again);
    final json = srs.toJson();

    final restored = SrsScheduler(clock: () => now)..loadJson(json);
    expect(restored.cardFor('a').repetitions, 2);
    expect(restored.cardFor('a').intervalDays, 3);
    expect(restored.cardFor('b').lapses, 1);
    expect(restored.cardFor('a').dueAt, srs.cardFor('a').dueAt);
  });
}
