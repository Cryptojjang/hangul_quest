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

    expect(find.text('한글퀘스트'), findsOneWidget);
    expect(find.textContaining('7일 한글 완독'), findsOneWidget);
    expect(find.text('자모 사냥'), findsOneWidget);
    expect(find.text('글자 조립'), findsOneWidget);
    expect(find.text('자모 도감'), findsOneWidget);
    expect(state.progress.onboardingDone, isTrue);
  });

  testWidgets('home → mini lesson → jamo hunt gameplay', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('자모 사냥'));
    await tester.pumpAndSettle();
    expect(find.text('플레이'), findsOneWidget,
        reason: 'mini lesson gates the stage');
    expect(find.text('건너뛰기 →'), findsOneWidget);

    await tester.tap(find.text('플레이'));
    await settleRoute(tester);
    expect(find.text('이 소리의 자모를 찾으세요'), findsOneWidget);
    expect(find.byIcon(Icons.volume_up), findsOneWidget);

    // Leave the stage (cancels round timers).
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('한글퀘스트'), findsOneWidget);
  });

  testWidgets('codex opens with locked cards; review teaser opens',
      (tester) async {
    final state = await pumpApp(tester);
    state.progress.unlockCodex('c_giyeok');

    await tester.tap(find.text('자모 도감'));
    await tester.pumpAndSettle();
    expect(find.textContaining('자모 도감  1/'), findsOneWidget);
    expect(find.text('기역'), findsOneWidget);
    expect(find.text('미발견'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('스마트 복습'));
    await tester.pumpAndSettle();
    expect(find.textContaining('스마트 복습  1/'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
  });

  testWidgets('locked stage 3 routes to paywall; purchase unlocks',
      (tester) async {
    final state = await pumpApp(tester);

    await tester.tap(find.text('단어 러시'));
    await tester.pumpAndSettle();

    // Paywall with required disclosures.
    expect(find.text('한글, 끝까지 읽어내세요'), findsOneWidget);
    expect(find.text('7일 무료로 시작하기'), findsOneWidget);
    expect(find.text('구매 복원'), findsOneWidget);
    expect(find.text('해지 안내'), findsOneWidget);
    expect(find.text('개인정보 처리방침'), findsOneWidget);
    expect(find.text('이용약관'), findsOneWidget);
    expect(find.text('연간 플랜'), findsOneWidget);

    await tester.tap(find.text('이용약관'));
    await tester.pumpAndSettle();
    expect(find.textContaining('자동 갱신'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('SAVE 52%'), findsOneWidget);

    await tester.tap(find.text('7일 무료로 시작하기'));
    await tester.pumpAndSettle();
    expect(state.isPremium, isTrue);

    // Stage 3 now opens: mini lesson instead of paywall.
    await tester.tap(find.text('단어 러시'));
    await tester.pumpAndSettle();
    expect(find.text('플레이'), findsOneWidget);
    await tester.tap(find.text('건너뛰기 →'));
    await settleRoute(tester);
    expect(find.text('읽고, 맞는 그림을 고르세요'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
  });

  testWidgets('settings shows subscription + privacy screens', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('구독 관리 · 해지 안내'), findsOneWidget);

    await tester.tap(find.text('구독 관리 · 해지 안내'));
    await tester.pumpAndSettle();
    expect(find.textContaining('구독 취소'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('개인정보 처리방침'));
    await tester.pumpAndSettle();
    expect(find.textContaining('온디바이스'), findsOneWidget);
  });
}
