import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/core/data/curriculum.dart';
import 'package:hangul_quest/core/economy/content_gate.dart';
import 'package:hangul_quest/platform/billing/billing.dart';

/// A stand-in for "core game logic": it only knows EntitlementState and the
/// gate — proving a gateway swap needs zero changes in core code. Whatever
/// gateway produced [status], the same call unlocks the same content.
bool coreLogicSeesPremium(SubscriptionStatus status) {
  final entitlements = EntitlementState(isPremium: status.isActive);
  const gate = ContentGate();
  return gate.canPlayLevel(entitlements, StageId.wordRush, 1).allowed;
}

void main() {
  group('gateway selection per build channel (spec §6)', () {
    test('dev → mock, appStore → storekit, playStore → play, web → stripe',
        () {
      expect(BillingConfig.gatewayFor(BuildChannel.dev).backendId, 'mock');
      expect(BillingConfig.gatewayFor(BuildChannel.appStore).backendId,
          'storekit');
      expect(
          BillingConfig.gatewayFor(BuildChannel.playStore).backendId, 'play');
      expect(BillingConfig.gatewayFor(BuildChannel.web).backendId, 'stripe');
    });

    test('store builds refuse non-store gateways (guideline 3.1.1)', () {
      expect(
          BillingConfig.isValidPairing(
              BuildChannel.appStore, StripeBillingGateway()),
          isFalse);
      expect(
          BillingConfig.isValidPairing(
              BuildChannel.appStore, MockBillingGateway()),
          isFalse);
      expect(
          BillingConfig.isValidPairing(
              BuildChannel.playStore, StripeBillingGateway()),
          isFalse);
      expect(
          BillingConfig.isValidPairing(
              BuildChannel.appStore, StoreKitBillingGateway()),
          isTrue);
      expect(
          BillingConfig.isValidPairing(BuildChannel.web, StripeBillingGateway()),
          isTrue);
      expect(
          BillingConfig.isValidPairing(BuildChannel.dev, MockBillingGateway()),
          isTrue);
    });
  });

  group('mock gateway end-to-end', () {
    test('purchase yearly starts a 7-day trial and activates premium',
        () async {
      final now = DateTime(2026, 7, 17);
      final billing = MockBillingGateway(clock: () => now);
      final products = await billing.fetchProducts();

      final yearly =
          products.firstWhere((p) => p.plan == SubscriptionPlan.yearly);
      expect(yearly.id, 'hq_premium_yearly');
      expect(yearly.savingsLabel, isNotNull,
          reason: 'yearly plan must carry the savings badge');
      expect(products.first.plan, SubscriptionPlan.yearly,
          reason: 'yearly listed first / preselected');

      final result = await billing.purchase(yearly);
      expect(result.success, isTrue);
      expect(result.isTrial, isTrue);

      final status = await billing.restore();
      expect(status.isActive, isTrue);
      expect(status.inTrial, isTrue);
      expect(status.expiresAt, now.add(const Duration(days: 7)));
      await billing.dispose();
    });

    test('status stream fires on purchase and on expiry', () async {
      final billing = MockBillingGateway();
      final events = <SubscriptionStatus>[];
      final sub = billing.statusStream.listen(events.add);

      final products = await billing.fetchProducts();
      await billing.purchase(products.first);
      billing.debugExpire();
      await Future<void>.delayed(Duration.zero);

      expect(events.length, 2);
      expect(events[0].isActive, isTrue);
      expect(events[1].isActive, isFalse);
      await sub.cancel();
      await billing.dispose();
    });
  });

  test(
      'swap mock → stripe: same Product/SubscriptionStatus types flow through, '
      'core logic untouched', () async {
    for (final gateway in [MockBillingGateway(), StripeBillingGateway()]) {
      final products = await gateway.fetchProducts();
      expect(products.map((p) => p.id),
          containsAll(['hq_premium_monthly', 'hq_premium_yearly']),
          reason: '${gateway.backendId} must expose the same catalog');
      await gateway.dispose();
    }
  });

  test('core logic reads the same SubscriptionStatus shape from any gateway',
      () async {
    // Inactive status (any backend) → stage 3 locked.
    expect(coreLogicSeesPremium(SubscriptionStatus.none), isFalse);

    // Active status produced by the mock backend → stage 3 open.
    final billing = MockBillingGateway();
    final products = await billing.fetchProducts();
    await billing.purchase(products.first);
    final status = await billing.restore();
    expect(coreLogicSeesPremium(status), isTrue);
    await billing.dispose();
  });
}
