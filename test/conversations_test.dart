import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/core/data/conversations.dart';
import 'package:hangul_quest/core/data/curriculum.dart';
import 'package:hangul_quest/core/data/vocab.dart';
import 'package:hangul_quest/core/economy/content_gate.dart';
import 'package:hangul_quest/features/paywall/paywall_screen.dart';

import 'widget_smoke_test.dart' show pumpApp, settleRoute;

void main() {
  group('conversation content', () {
    test('every line and phrase has Korean, romanization and English', () {
      for (final c in conversations) {
        expect(c.lines, isNotEmpty, reason: c.id);
        expect(c.phrases, isNotEmpty, reason: c.id);
        expect(c.cultureTip, isNotEmpty, reason: c.id);
        for (final l in c.lines) {
          expect([
            l.korean,
            l.romanization,
            l.english,
            l.speaker
          ], everyElement(isNotEmpty), reason: '${c.id}: ${l.korean}');
        }
        for (final p in c.phrases) {
          expect(
              [p.korean, p.romanization, p.english], everyElement(isNotEmpty),
              reason: '${c.id}: ${p.korean}');
        }
      }
    });

    test('ids and audio slots are unique', () {
      final ids = conversations.map((c) => c.id).toList();
      expect(ids.toSet().length, ids.length);
      final slots = [
        for (final c in conversations) ...[
          for (var i = 0; i < c.lines.length; i++) c.lineSlot(i),
          for (var i = 0; i < c.phrases.length; i++) c.phraseSlot(i),
        ],
      ];
      expect(slots.toSet().length, slots.length);
    });

    test('free taster is a strict subset', () {
      expect(freeConversationCount, greaterThan(0));
      expect(freeConversationCount, lessThan(conversations.length));
    });
  });

  group('conversation gate', () {
    const gate = ContentGate();
    const free = EntitlementState();
    const premium = EntitlementState(isPremium: true);

    test('first N free, rest premium with a paywall trigger', () {
      for (var i = 0; i < conversations.length; i++) {
        final d = gate.canOpenConversation(free, i);
        expect(d.allowed, i < freeConversationCount, reason: 'index $i');
        if (!d.allowed) {
          expect(gate.paywallTriggerFor(d.reason), 'conversation_lock');
        }
        expect(gate.canOpenConversation(premium, i).allowed, isTrue);
      }
    });
  });

  group('expanded vocabulary', () {
    test('every Word Rush level word exists in the vocabulary', () {
      for (final l in stage3Levels) {
        for (final id in l.wordIds) {
          expect(vocabById[id], isNotNull, reason: 'level ${l.level}: $id');
        }
      }
    });

    test('Korean spellings are unique (no ambiguous answers)', () {
      final ko = vocabWords.map((w) => w.korean).toList();
      expect(ko.toSet().length, ko.length);
    });

    test('vocabulary covers well over 150 words', () {
      expect(vocabWords.length, greaterThan(150));
    });
  });

  testWidgets('home → conversations: free opens, locked shows paywall',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Real-life Korean · 상황별 대화'));
    await tester.pumpAndSettle();
    expect(find.text('FREE'), findsNWidgets(freeConversationCount));

    await tester.tap(find.text(conversations.first.title));
    await settleRoute(tester);
    // The list builds lazily — scroll down to the phrases and culture tip.
    await tester.scrollUntilVisible(find.text('Culture tip'), 300);
    expect(find.text('Culture tip'), findsOneWidget);
    expect(find.text('Key phrases'), findsOneWidget);
    await tester.pageBack();
    await settleRoute(tester);

    await tester.tap(find.text(conversations[freeConversationCount].title));
    await settleRoute(tester);
    expect(find.byType(PaywallScreen), findsOneWidget);
    expect(find.text('Key phrases'), findsNothing);
  });
}
