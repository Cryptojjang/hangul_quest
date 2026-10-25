/// Billing abstraction — the store-dependency isolation seam (spec §6).
///
/// Game/learning code depends ONLY on [BillingGateway]. Swapping
/// mock ↔ StoreKit ↔ Play Billing ↔ Lemon Squeezy is a construction-time choice in
/// [BillingConfig.gatewayFor]; no core logic changes. Verified by
/// test/billing_switch_test.dart.
library;

import 'dart:async';

import 'storekit_billing.dart';

export 'storekit_billing.dart' show StoreKitBillingGateway;

enum SubscriptionPlan { monthly, yearly, lifetime }

class Product {
  const Product({
    required this.id,
    required this.plan,
    required this.priceLabel,
    required this.trialDays,
    this.savingsLabel,
  });

  final String id;
  final SubscriptionPlan plan;

  /// Localized display price supplied by the store; mock uses fixed strings.
  final String priceLabel;
  final int trialDays;
  final String? savingsLabel;
}

class PurchaseResult {
  const PurchaseResult(
      {required this.success, this.isTrial = false, this.error});

  final bool success;
  final bool isTrial;
  final String? error;
}

class SubscriptionStatus {
  const SubscriptionStatus({
    required this.isActive,
    this.plan,
    this.inTrial = false,
    this.expiresAt,
  });

  final bool isActive;
  final SubscriptionPlan? plan;
  final bool inTrial;
  final DateTime? expiresAt;

  static const none = SubscriptionStatus(isActive: false);
}

/// The seam. Implementations must be side-effect free on construction so the
/// app can swap them without touching game state.
abstract class BillingGateway {
  /// Backend identifier, e.g. 'mock', 'storekit', 'play', 'lemonsqueezy'.
  String get backendId;

  /// Whether this gateway may run inside a store-distributed build.
  /// Lemon Squeezy returns false: App Store builds must never ship external payment
  /// paths (spec §5.2 / review guideline 3.1.1).
  bool get allowedInStoreBuild;

  Future<List<Product>> fetchProducts();
  Future<PurchaseResult> purchase(Product product);
  Future<SubscriptionStatus> restore();
  Stream<SubscriptionStatus> get statusStream;
  Future<void> dispose();
}

/// Optional gateway capability (web): restore a purchase on a new device by
/// proving ownership of the checkout email with a mailed one-time code. No
/// accounts — the code is checked server-side (api/restore-email.js).
abstract class EmailRestore {
  /// Asks the server to mail a code, written in [lang] (an l10n locale code
  /// such as 'ja' or 'zh_TW'). Completes the same way whether or not the
  /// email bought anything; false only if the server couldn't be reached.
  Future<bool> requestRestoreCode(String email, {required String lang});

  /// Redeems the mailed [code]; null when it is wrong or expired. An active
  /// status is also pushed on [BillingGateway.statusStream]. Throws when
  /// the server can't be reached.
  Future<SubscriptionStatus?> redeemRestoreCode(String email, String code);
}

/// Distribution channel of the running build.
enum BuildChannel { appStore, playStore, web, dev }

class BillingConfig {
  /// Selects the gateway for a build channel. THE swap point.
  static BillingGateway gatewayFor(BuildChannel channel) => switch (channel) {
        BuildChannel.dev => MockBillingGateway(),
        BuildChannel.appStore => StoreKitBillingGateway(),
        BuildChannel.playStore => PlayBillingGateway(),
        BuildChannel.web => LemonSqueezyBillingGateway(),
      };

  /// Guard used by tests and a debug assert at startup: a store build must
  /// never be wired to a gateway that isn't store-compliant.
  static bool isValidPairing(BuildChannel channel, BillingGateway gateway) {
    final isStore =
        channel == BuildChannel.appStore || channel == BuildChannel.playStore;
    if (isStore && !gateway.allowedInStoreBuild) return false;
    return true;
  }
}

// Web/dev catalog. Hangul takes about a week to learn, so the main offer is
// a one-time lifetime unlock; monthly stays as a low-commitment option. The
// free tier (stage 1 + first half of stage 2) is the trial, so no free-trial
// period is attached.
const _monthly = Product(
  id: 'hq_premium_monthly',
  plan: SubscriptionPlan.monthly,
  priceLabel: r'$4.99/mo',
  trialDays: 0,
);
const _lifetime = Product(
  id: 'hq_premium_lifetime',
  plan: SubscriptionPlan.lifetime,
  priceLabel: r'$12.99 once',
  trialDays: 0,
  savingsLabel: 'BEST VALUE',
);

/// Dev-phase gateway: in-memory subscription state, instant success.
class MockBillingGateway implements BillingGateway {
  MockBillingGateway({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final _controller = StreamController<SubscriptionStatus>.broadcast();
  SubscriptionStatus _status = SubscriptionStatus.none;

  @override
  String get backendId => 'mock';

  @override
  bool get allowedInStoreBuild => false; // dev only — never ship

  @override
  Future<List<Product>> fetchProducts() async => const [_lifetime, _monthly];

  @override
  Future<PurchaseResult> purchase(Product product) async {
    final now = _clock();
    _status = SubscriptionStatus(
      isActive: true,
      plan: product.plan,
      inTrial: product.trialDays > 0,
      expiresAt: product.plan == SubscriptionPlan.lifetime
          ? null
          : now.add(Duration(
              days: product.trialDays > 0
                  ? product.trialDays
                  : (product.plan == SubscriptionPlan.yearly ? 365 : 30))),
    );
    _controller.add(_status);
    return PurchaseResult(success: true, isTrial: product.trialDays > 0);
  }

  @override
  Future<SubscriptionStatus> restore() async => _status;

  @override
  Stream<SubscriptionStatus> get statusStream => _controller.stream;

  @override
  Future<void> dispose() => _controller.close();

  /// Test hook: simulate expiry/cancellation.
  void debugExpire() {
    _status = SubscriptionStatus.none;
    _controller.add(_status);
  }
}

// StoreKitBillingGateway lives in storekit_billing.dart (platform-channel
// implementation over ios/Runner/BillingChannel.swift) and is re-exported
// above so call sites keep importing billing.dart only.

/// Google Play gateway (Play Billing). Channel lands with the Android
/// release milestone; interface and product ids are final.
class PlayBillingGateway implements BillingGateway {
  final _controller = StreamController<SubscriptionStatus>.broadcast();

  @override
  String get backendId => 'play';

  @override
  bool get allowedInStoreBuild => true;

  @override
  Future<List<Product>> fetchProducts() async {
    throw UnimplementedError('Play Billing not wired on this platform');
  }

  @override
  Future<PurchaseResult> purchase(Product product) async {
    throw UnimplementedError('Play Billing not wired on this platform');
  }

  @override
  Future<SubscriptionStatus> restore() async {
    throw UnimplementedError('Play Billing not wired on this platform');
  }

  @override
  Stream<SubscriptionStatus> get statusStream => _controller.stream;

  @override
  Future<void> dispose() => _controller.close();
}

/// Lemon Squeezy gateway — web deployment ONLY ([allowedInStoreBuild] is false, and
/// BillingConfig never pairs it with a store channel).
class LemonSqueezyBillingGateway implements BillingGateway {
  final _controller = StreamController<SubscriptionStatus>.broadcast();

  @override
  String get backendId => 'lemonsqueezy';

  @override
  bool get allowedInStoreBuild => false;

  @override
  Future<List<Product>> fetchProducts() async => const [_lifetime, _monthly];

  @override
  Future<PurchaseResult> purchase(Product product) async {
    // Real web checkout lives in web_billing.dart (Lemon.js overlay).
    throw UnimplementedError('Lemon Squeezy checkout not wired in this build');
  }

  @override
  Future<SubscriptionStatus> restore() async => SubscriptionStatus.none;

  @override
  Stream<SubscriptionStatus> get statusStream => _controller.stream;

  @override
  Future<void> dispose() => _controller.close();
}
