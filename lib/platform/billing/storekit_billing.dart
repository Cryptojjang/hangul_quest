/// StoreKit 2 gateway — Dart side of the `hq/billing` platform channel
/// (host: ios/Runner/BillingChannel.swift). Store-compliant: no external
/// payment paths.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'billing.dart';

class StoreKitBillingGateway implements BillingGateway {
  StoreKitBillingGateway({
    @visibleForTesting MethodChannel? channel,
    @visibleForTesting EventChannel? statusChannel,
  })  : _channel = channel ?? const MethodChannel('hq/billing'),
        _statusChannel =
            statusChannel ?? const EventChannel('hq/billing/status');

  final MethodChannel _channel;
  final EventChannel _statusChannel;
  StreamSubscription<dynamic>? _nativeSub;
  final _controller = StreamController<SubscriptionStatus>.broadcast();

  @override
  String get backendId => 'storekit';

  @override
  bool get allowedInStoreBuild => true;

  static SubscriptionStatus _statusFrom(Map<dynamic, dynamic> m) =>
      SubscriptionStatus(
        isActive: m['isActive'] as bool? ?? false,
        plan: switch (m['plan'] as String?) {
          'yearly' => SubscriptionPlan.yearly,
          'monthly' => SubscriptionPlan.monthly,
          _ => null,
        },
        inTrial: m['inTrial'] as bool? ?? false,
        expiresAt: m['expiresAtMillis'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                m['expiresAtMillis'] as int),
      );

  @override
  Future<List<Product>> fetchProducts() async {
    final raw = await _channel.invokeListMethod<dynamic>('fetchProducts');
    return [
      for (final item in raw ?? const [])
        Product(
          id: item['id'] as String,
          plan: item['plan'] == 'yearly'
              ? SubscriptionPlan.yearly
              : SubscriptionPlan.monthly,
          priceLabel: item['priceLabel'] as String,
          trialDays: item['trialDays'] as int? ?? 0,
          savingsLabel: item['savingsLabel'] as String?,
        ),
    ];
  }

  @override
  Future<PurchaseResult> purchase(Product product) async {
    final m = await _channel
        .invokeMapMethod<dynamic, dynamic>('purchase', {'id': product.id});
    final result = PurchaseResult(
      success: m?['success'] as bool? ?? false,
      isTrial: m?['isTrial'] as bool? ?? false,
      error: m?['error'] as String?,
    );
    if (result.success) {
      _controller.add(await restore());
    }
    return result;
  }

  @override
  Future<SubscriptionStatus> restore() async {
    final m = await _channel.invokeMapMethod<dynamic, dynamic>('restore');
    return m == null ? SubscriptionStatus.none : _statusFrom(m);
  }

  @override
  Stream<SubscriptionStatus> get statusStream {
    // Lazily attach to the native Transaction.updates stream on first listen.
    _nativeSub ??= _statusChannel.receiveBroadcastStream().listen(
      (event) {
        if (event is Map) _controller.add(_statusFrom(event));
      },
      onError: (Object _) {}, // native stream errors must not kill the app
    );
    return _controller.stream;
  }

  @override
  Future<void> dispose() async {
    await _nativeSub?.cancel();
    await _controller.close();
  }
}
