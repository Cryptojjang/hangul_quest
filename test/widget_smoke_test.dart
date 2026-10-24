/// Widget-level smoke test of the real screen flow:
/// onboarding → home map → mini lesson → stage 1 play → codex → review →
/// paywall → purchase → stage 3 → settings/legal screens.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/app.dart';
import 'package:hangul_quest/state/app_state.dart';
import 'package:hangul_quest/state/progress_store.dart';

Future<AppState> pumpApp(WidgetTester tester,
    {bool onboarded = true}) async {
  // Tall phone-ish viewport so the whole home map is on screen.
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final state = AppState(
      services: AppServices.dev(), store: ProgressStore(InMemoryStorage()));
  await state.init();
  state.progress.onboardingDone = onboarded;
  await tester.pumpWidget(HangulQuestApp(state: state));
  await tester.pumpAndSettle();
  return state;
}

/// Push transitions are 250ms; two pumps land the destination screen without
/// pumpAndSettle (game screens run periodic timers that never settle).
Future<void> settleRoute(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  testWidgets('onboarding → home', (tester) async {
    final state = await pumpApp(tester, onboarded: false);

    expect(find.text('Skip'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.textContaining('in 7 days'), findsOneWidget);
    expect(find.text('Fluent reader'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Hangul Bricks'), findsOneWidget);
    expect(find.textContaining('READ HANGUL IN 7 DAYS'), findsOneWidget);
    expect(find.text('Jamo Hunt'), findsOneWidget);
    expect(find.text('Letter Builder'), findsOneWidget);
    expect(find.text('Letter Codex'), findsOneWidget);
    expect(state.progress.onboardingDone, isTrue);
  });

  testWidgets('home → mini lesson → jamo hunt gameplay', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Jamo Hunt'));
    await tester.pumpAndSettle();
    expect(find.text('Play'), findsOneWidget,
        reason: 'mini lesson gates the stage');
    expect(find.text('Skip →'), findsOneWidget);

    await tester.tap(find.text('Play'));
    await settleRoute(tester);
    expect(find.text('Find the letter for this sound'), findsOneWidget);
    expect(find.byIcon(Icons.volume_up), findsOneWidget);

    // Leave the stage (cancels round timers).
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Hangul Bricks'), findsOneWidget);
  });

  testWidgets('codex opens with locked cards; review teaser opens',
      (tester) async {
    final state = await pumpApp(tester);
    state.progress.unlockCodex('c_giyeok');

    await tester.tap(find.text('Letter Codex'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Letter Codex  1/'), findsOneWidget);
    expect(find.text('기역'), findsOneWidget);
    expect(find.text('Locked'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Smart Review'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Smart Review  1/'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
  });

  testWidgets('locked stage 3 routes to paywall; purchase unlocks',
      (tester) async {
    final state = await pumpApp(tester);

    await tester.tap(find.text('Word Rush'));
    await tester.pumpAndSettle();

    // Paywall with required disclosures.
    expect(find.text('Read Hangul all the way'), findsOneWidget);
    expect(find.text('Start 7-day free trial'), findsOneWidget);
    expect(find.text('Restore purchase'), findsOneWidget);
    expect(find.text('How to cancel'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('Terms of Use'), findsOneWidget);
    expect(find.text('Yearly'), findsOneWidget);

    await tester.tap(find.text('Terms of Use'));
    await tester.pumpAndSettle();
    expect(find.textContaining('auto-renews'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('SAVE 52%'), findsOneWidget);

    await tester.tap(find.text('Start 7-day free trial'));
    await tester.pumpAndSettle();
    expect(state.isPremium, isTrue);

    // Stage 3 now opens: mini lesson instead of paywall.
    await tester.tap(find.text('Word Rush'));
    await tester.pumpAndSettle();
    expect(find.text('Play'), findsOneWidget);
    await tester.tap(find.text('Skip →'));
    await settleRoute(tester);
    expect(find.text('Read it, then pick the matching picture'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
  });

  testWidgets('settings shows subscription + privacy screens', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Manage subscription'), findsOneWidget);

    await tester.tap(find.text('Manage subscription'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Apple ID → Subscriptions'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Privacy Policy'));
    await tester.pumpAndSettle();
    expect(find.textContaining('on-device'), findsOneWidget);
  });
}
