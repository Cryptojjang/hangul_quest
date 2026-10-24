/// Web billing gateway — Lemon Squeezy checkout (Lemon.js overlay) via the
/// /api serverless functions. When the deployment has no Lemon Squeezy env
/// vars, /api/config reports demo mode and this gateway delegates to
/// [MockBillingGateway] with a clearly-labeled fake purchase, so the deployed
/// demo stays fully playable.
///
/// Store rule (spec §5.2): this file is web-only and never ships in store
/// builds — conditional import in main.dart.
library;

import 'dart:async';
import 'dart:convert';
// Migration to package:web is queued with the wasm-gc milestone; dart:html
// remains correct for the js-compiled web target we ship today.
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:js_util' as js_util;

import 'billing.dart';

BillingGateway? createWebBillingGateway({
  required String? Function() getCustomerId,
  required void Function(String) saveCustomerId,
}) =>
    WebBillingGateway(
        getCustomerId: getCustomerId, saveCustomerId: saveCustomerId);

class WebBillingGateway implements BillingGateway {
  WebBillingGateway({
    required this.getCustomerId,
    required this.saveCustomerId,
  });

  /// Restore token ("orderId:identifier") persisted after a checkout.
  final String? Function() getCustomerId;
  final void Function(String) saveCustomerId;

  final _controller = StreamController<SubscriptionStatus>.broadcast();
  MockBillingGateway? _demo; // set when /api/config says payments are off
  bool _configLoaded = false;

  Future<Map<String, dynamic>> _api(String path,
      [Map<String, dynamic>? body]) async {
    final req = await html.HttpRequest.request(
      path,
      method: body == null ? 'GET' : 'POST',
      sendData: body == null ? null : jsonEncode(body),
      requestHeaders: {'Content-Type': 'application/json'},
    );
    return jsonDecode(req.responseText ?? '{}') as Map<String, dynamic>;
  }

  Future<void> _ensureConfig() async {
    if (_configLoaded) return;
    try {
      final config = await _api('/api/config');
      if (config['paymentsEnabled'] != true) _demo = MockBillingGateway();
    } catch (_) {
      _demo = MockBillingGateway(); // no API reachable → demo
    }
    _configLoaded = true;
  }

  @override
  String get backendId => _demo == null ? 'lemonsqueezy' : 'demo';

  @override
  bool get allowedInStoreBuild => false;

  @override
  Future<List<Product>> fetchProducts() async {
    await _ensureConfig();
    if (_demo != null) return _demo!.fetchProducts();
    return const [
      Product(
        id: 'hq_premium_lifetime',
        plan: SubscriptionPlan.lifetime,
        priceLabel: r'$12.99 once',
        trialDays: 0,
        savingsLabel: 'BEST VALUE',
      ),
      Product(
        id: 'hq_premium_monthly',
        plan: SubscriptionPlan.monthly,
        priceLabel: r'$4.99/mo',
        trialDays: 0,
      ),
    ];
  }

  @override
  Future<PurchaseResult> purchase(Product product) async {
    await _ensureConfig();
    if (_demo != null) {
      final result = await _demo!.purchase(product);
      if (result.success) _controller.add(await _demo!.restore());
      return result;
    }
    final lemon = js_util.getProperty<Object?>(html.window, 'LemonSqueezy');
    if (lemon == null) {
      return const PurchaseResult(
          success: false, error: 'Could not load checkout. Please refresh');
    }
    final res = await _api('/api/checkout', {'plan': product.plan.name});
    final url = res['url'] as String?;
    if (url == null) {
      return PurchaseResult(
          success: false, error: res['error'] as String? ?? 'checkout failed');
    }

    final token = await _openOverlay(lemon, url);
    if (token == null) {
      return const PurchaseResult(success: false, error: 'Checkout cancelled');
    }
    saveCustomerId(token);
    final status = await _verify(token);
    _controller.add(status);
    return status.isActive
        ? PurchaseResult(success: true, isTrial: status.inTrial)
        : const PurchaseResult(
            success: false, error: 'Could not confirm payment. Tap Restore purchase');
  }

  /// Opens the Lemon.js overlay and resolves with the restore token on
  /// success, or null once the overlay is closed without a purchase.
  /// index.html bridges Lemon.js' Checkout.Success to an `hq-ls-success`
  /// window event; Lemon.js has no close event, so the overlay's iframe is
  /// polled instead.
  Future<String?> _openOverlay(Object lemon, String url) {
    final done = Completer<String?>();
    late final StreamSubscription<html.Event> sub;
    Timer? poll;
    void finish(String? token) {
      if (done.isCompleted) return;
      poll?.cancel();
      sub.cancel();
      done.complete(token);
    }

    sub = html.window.on['hq-ls-success'].listen((e) {
      final detail = (e as html.CustomEvent).detail;
      finish(detail is String ? detail : null);
    });
    js_util.callMethod<void>(
        js_util.getProperty<Object>(lemon, 'Url'), 'Open', [url]);

    var seen = false;
    poll = Timer.periodic(const Duration(milliseconds: 800), (_) {
      final open =
          html.document.querySelector('iframe[src*="lemonsqueezy.com"]') !=
              null;
      if (open) seen = true;
      // Grace period: the success event can land just after the overlay closes.
      if (seen && !open) {
        Future.delayed(const Duration(milliseconds: 1500), () => finish(null));
      }
    });
    return done.future;
  }

  Future<SubscriptionStatus> _verify(String token) async {
    try {
      return _statusFrom(await _api('/api/verify', {'token': token}));
    } catch (_) {
      return SubscriptionStatus.none;
    }
  }

  @override
  Future<SubscriptionStatus> restore() async {
    await _ensureConfig();
    if (_demo != null) return _demo!.restore();
    final token = getCustomerId();
    if (token == null) return SubscriptionStatus.none;
    return _verify(token);
  }

  static SubscriptionStatus _statusFrom(Map<String, dynamic> m) =>
      SubscriptionStatus(
        isActive: m['isActive'] == true,
        plan: switch (m['plan'] as String?) {
          'lifetime' => SubscriptionPlan.lifetime,
          'yearly' => SubscriptionPlan.yearly,
          'monthly' => SubscriptionPlan.monthly,
          _ => null,
        },
        inTrial: m['inTrial'] == true,
        expiresAt: m['expiresAtMillis'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                (m['expiresAtMillis'] as num).toInt()),
      );

  @override
  Stream<SubscriptionStatus> get statusStream => _controller.stream;

  @override
  Future<void> dispose() async {
    await _demo?.dispose();
    await _controller.close();
  }
}
