/// "Restore with email" UI path: only offered by gateways with
/// [EmailRestore] (the live web gateway), and a correct mailed code unlocks
/// Premium from the paywall.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/app.dart';
import 'package:hangul_quest/platform/billing/billing.dart';
import 'package:hangul_quest/platform/speech/pronunciation_scorer.dart';
import 'package:hangul_quest/platform/speech/speech.dart';
import 'package:hangul_quest/platform/audio/audio_asset_manager.dart';
import 'package:hangul_quest/platform/device/device.dart';
import 'package:hangul_quest/core/events/analytics.dart';
import 'package:hangul_quest/state/app_state.dart';
import 'package:hangul_quest/state/progress_store.dart';

import 'widget_smoke_test.dart' show pumpApp;

/// Stands in for the web gateway: the "mailed" code is ABCD2345.
class FakeEmailRestoreGateway extends MockBillingGateway
    implements EmailRestore {
  final requested = <String>[];
  final langs = <String>[];
  final _status = StreamController<SubscriptionStatus>.broadcast();
  SubscriptionStatus _restored = SubscriptionStatus.none;

  @override
  String get backendId => 'lemonsqueezy';

  @override
  Future<bool> requestRestoreCode(String email, {required String lang}) async {
    requested.add(email);
    langs.add(lang);
    return true;
  }

  @override
  Future<SubscriptionStatus?> redeemRestoreCode(
      String email, String code) async {
    if (code.replaceAll('-', '').toUpperCase() != 'ABCD2345') return null;
    _restored = const SubscriptionStatus(
        isActive: true, plan: SubscriptionPlan.lifetime);
    _status.add(_restored);
    return _restored;
  }

  @override
  Future<SubscriptionStatus> restore() async => _restored;

  @override
  Stream<SubscriptionStatus> get statusStream => _status.stream;
}

Future<AppState> pumpWithGateway(
    WidgetTester tester, BillingGateway billing) async {
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final state = AppState(
    services: AppServices(
      billing: billing,
      speech: FakeSpeechRecognizer(scriptedTranscript: '안녕'),
      scorer: const JamoSimilarityScorer(),
      audio: DevAudioManager(),
      haptics: NoopHaptics(),
      push: NoopPush(),
      analytics: LocalAnalytics(),
      channel: BuildChannel.dev,
    ),
    store: ProgressStore(InMemoryStorage()),
  );
  await state.init();
  state.progress.onboardingDone = true;
  await tester.pumpWidget(HangulQuestApp(state: state));
  await tester.pumpAndSettle();
  return state;
}

void main() {
  testWidgets('not offered when the gateway has no email restore',
      (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Restore purchase'), findsOneWidget);
    expect(find.text('Restore with email'), findsNothing);
  });

  testWidgets('paywall: email → mailed code unlocks Premium', (tester) async {
    final gateway = FakeEmailRestoreGateway();
    final state = await pumpWithGateway(tester, gateway);

    await tester.tap(find.text('Word Rush'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restore with email'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), ' fan@mail.com ');
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();
    expect(gateway.requested, ['fan@mail.com']);
    expect(gateway.langs, ['en']);
    expect(find.textContaining('a code is on its way'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'WRONG123');
    await tester.tap(find.text('Restore'));
    await tester.pumpAndSettle();
    expect(find.text('That code is wrong or has expired.'), findsOneWidget);
    expect(state.isPremium, isFalse);

    await tester.enterText(find.byType(TextField), 'abcd-2345');
    await tester.tap(find.text('Restore'));
    await tester.pumpAndSettle();

    expect(state.isPremium, isTrue);
    expect(find.text('Subscription restored'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Unlock Premium'), findsNothing, reason: 'paywall closed');
  });

  testWidgets('settings offers restore with email', (tester) async {
    await pumpWithGateway(tester, FakeEmailRestoreGateway());
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restore with email'));
    await tester.pumpAndSettle();
    expect(find.text('Send code'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });
}
