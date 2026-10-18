/// Dart↔iOS channel protocol tests. The native side is mocked at the binary
/// messenger, so these verify the exact payload contract implemented in
/// ios/Runner/{BillingChannel,SpeechChannel}.swift and that the REAL
/// StoreKit gateway drives core game logic unchanged.
library;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/core/data/curriculum.dart';
import 'package:hangul_quest/core/economy/content_gate.dart';
import 'package:hangul_quest/platform/billing/billing.dart';
import 'package:hangul_quest/platform/speech/ios_speech_recognizer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  group('hq/billing channel', () {
    const channel = MethodChannel('hq/billing');
    var active = false;

    setUp(() {
      active = false;
      messenger.setMockMethodCallHandler(channel, (call) async {
        switch (call.method) {
          case 'fetchProducts':
            return [
              {
                'id': 'hq_premium_yearly',
                'plan': 'yearly',
                'priceLabel': '₩54,000/yr',
                'trialDays': 7,
                'savingsLabel': 'SAVE 52%',
              },
              {
                'id': 'hq_premium_monthly',
                'plan': 'monthly',
                'priceLabel': '₩9,500/mo',
                'trialDays': 7,
              },
            ];
          case 'purchase':
            final id = (call.arguments as Map)['id'] as String;
            if (id == 'hq_premium_yearly') {
              active = true;
              return {'success': true, 'isTrial': true};
            }
            return {'success': false, 'isTrial': false, 'error': 'cancelled'};
          case 'restore':
            return {
              'isActive': active,
              if (active) 'plan': 'yearly',
              'inTrial': active,
              if (active)
                'expiresAtMillis':
                    DateTime(2026, 7, 25).millisecondsSinceEpoch,
            };
          default:
            throw MissingPluginException();
        }
      });
    });

    tearDown(() => messenger.setMockMethodCallHandler(channel, null));

    test('fetchProducts maps native payload; yearly first with savings badge',
        () async {
      final gateway = StoreKitBillingGateway();
      final products = await gateway.fetchProducts();
      expect(products, hasLength(2));
      expect(products.first.plan, SubscriptionPlan.yearly);
      expect(products.first.savingsLabel, 'SAVE 52%');
      expect(products.first.trialDays, 7);
      expect(products.first.priceLabel, '₩54,000/yr');
      await gateway.dispose();
    });

    test('purchase → trial result, restore reflects entitlement', () async {
      final gateway = StoreKitBillingGateway();
      final products = await gateway.fetchProducts();

      final result = await gateway.purchase(products.first);
      expect(result.success, isTrue);
      expect(result.isTrial, isTrue);

      final status = await gateway.restore();
      expect(status.isActive, isTrue);
      expect(status.plan, SubscriptionPlan.yearly);
      expect(status.inTrial, isTrue);
      expect(status.expiresAt, DateTime(2026, 7, 25));
      await gateway.dispose();
    });

    test('cancelled purchase surfaces the error, stays inactive', () async {
      final gateway = StoreKitBillingGateway();
      final products = await gateway.fetchProducts();
      final result = await gateway.purchase(products.last);
      expect(result.success, isFalse);
      expect(result.error, 'cancelled');
      expect((await gateway.restore()).isActive, isFalse);
      await gateway.dispose();
    });

    test(
        'REAL StoreKit gateway (mocked native) unlocks core game logic — '
        'the store swap needs zero core changes', () async {
      final gateway = StoreKitBillingGateway();
      expect(
          BillingConfig.isValidPairing(BuildChannel.appStore, gateway), isTrue);

      const gate = ContentGate();
      var e = EntitlementState(
          isPremium: (await gateway.restore()).isActive);
      expect(gate.canPlayLevel(e, StageId.wordRush, 1).allowed, isFalse);

      final products = await gateway.fetchProducts();
      await gateway.purchase(products.first);
      e = EntitlementState(isPremium: (await gateway.restore()).isActive);
      expect(gate.canPlayLevel(e, StageId.wordRush, 1).allowed, isTrue);
      expect(
          gate
              .canPlayLevel(e, StageId.blockBuilder, stage2Levels.length)
              .allowed,
          isTrue);
      await gateway.dispose();
    });

    test('status event stream maps native entitlement updates', () async {
      messenger.setMockStreamHandler(
        const EventChannel('hq/billing/status'),
        MockStreamHandler.inline(
          onListen: (args, sink) {
            sink.success({'isActive': true, 'plan': 'monthly', 'inTrial': false});
            sink.endOfStream();
          },
        ),
      );
      final gateway = StoreKitBillingGateway();
      final status = await gateway.statusStream.first;
      expect(status.isActive, isTrue);
      expect(status.plan, SubscriptionPlan.monthly);
      await gateway.dispose();
    });
  });

  group('hq/speech channel', () {
    const channel = MethodChannel('hq/speech');

    tearDown(() => messenger.setMockMethodCallHandler(channel, null));

    test('listen maps transcript + confidence; params forwarded', () async {
      Map<dynamic, dynamic>? seenArgs;
      messenger.setMockMethodCallHandler(channel, (call) async {
        switch (call.method) {
          case 'isAvailable':
            return true;
          case 'requestPermission':
            return true;
          case 'listen':
            seenArgs = call.arguments as Map;
            return {'transcript': '안녕', 'confidence': 0.87};
          default:
            return null;
        }
      });

      final speech = IosSpeechRecognizer();
      expect(await speech.isAvailable(), isTrue);
      expect(await speech.requestPermission(), isTrue);

      final result = await speech.listen(
          maxDuration: const Duration(seconds: 3), locale: 'ko-KR');
      expect(result!.transcript, '안녕');
      expect(result.confidence, closeTo(0.87, 1e-9));
      expect(seenArgs!['maxSeconds'], 3.0);
      expect(seenArgs!['locale'], 'ko-KR');
    });

    test('non-iOS host (no channel) degrades to unavailable, never throws',
        () async {
      final speech = IosSpeechRecognizer();
      expect(await speech.isAvailable(), isFalse);
      expect(await speech.requestPermission(), isFalse);
    });

    test('null native result (recognizer unavailable) → null, UI can retry',
        () async {
      messenger.setMockMethodCallHandler(channel, (call) async => null);
      final speech = IosSpeechRecognizer();
      expect(await speech.listen(), isNull);
    });
  });
}
