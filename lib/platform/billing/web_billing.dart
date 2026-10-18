/// Web billing gateway — Stripe Checkout via the /api serverless functions
/// (deploy/api/*.js). When the deployment has no STRIPE_SECRET_KEY, /api/config
/// reports demo mode and this gateway delegates to [MockBillingGateway] with
/// a clearly-labeled fake purchase, so the deployed demo stays fully playable.
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

import 'billing.dart';

BillingGateway? createWebBillingGateway({
  required String? Function() getCustomerId,
  required void Function(String) saveCustomerId,
}) =>
    WebBillingGateway(
        getCustomerId: getCustomerId, saveCustomerId: saveCustomerId);

String? checkoutSessionFromUrl() =>
    Uri.base.queryParameters['session_id'];

/// Verifies a checkout session on the web gateway (type-erased so main.dart
/// compiles against the non-web stub too).
Future<void> confirmPendingCheckout(
    BillingGateway gateway, String sessionId) async {
  if (gateway is WebBillingGateway) {
    await gateway.confirmCheckout(sessionId);
  }
}

/// Strips the checkout params so a reload doesn't re-verify.
void clearCheckoutUrl() {
  final clean = Uri.base.removeFragment().replace(queryParameters: {});
  final s = clean.toString();
  html.window.history
      .replaceState(null, '', s.endsWith('?') ? s.substring(0, s.length - 1) : s);
}

class WebBillingGateway implements BillingGateway {
  WebBillingGateway({
    required this.getCustomerId,
    required this.saveCustomerId,
  });

  final String? Function() getCustomerId;
  final void Function(String) saveCustomerId;

  final _controller = StreamController<SubscriptionStatus>.broadcast();
  MockBillingGateway? _demo; // set when /api/config says stripe is off
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
      if (config['stripeEnabled'] != true) _demo = MockBillingGateway();
    } catch (_) {
      _demo = MockBillingGateway(); // no API reachable → demo
    }
    _configLoaded = true;
  }

  @override
  String get backendId => _demo == null ? 'stripe' : 'demo';

  @override
  bool get allowedInStoreBuild => false;

  @override
  Future<List<Product>> fetchProducts() async {
    await _ensureConfig();
    if (_demo != null) return _demo!.fetchProducts();
    return const [
      Product(
        id: 'hq_premium_yearly',
        plan: SubscriptionPlan.yearly,
        priceLabel: r'$39.99/yr',
        trialDays: 7,
        savingsLabel: 'SAVE 52%',
      ),
      Product(
        id: 'hq_premium_monthly',
        plan: SubscriptionPlan.monthly,
        priceLabel: r'$6.99/mo',
        trialDays: 7,
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
    final res = await _api('/api/checkout', {'plan': product.plan.name});
    final url = res['url'] as String?;
    if (url == null) {
      return PurchaseResult(
          success: false, error: res['error'] as String? ?? 'checkout failed');
    }
    html.window.location.assign(url); // → Stripe-hosted checkout
    // The page navigates away; this result is never observed.
    return const PurchaseResult(success: false, error: 'redirecting');
  }

  /// Called by main() when the page returns from Stripe with ?session_id=.
  Future<SubscriptionStatus> confirmCheckout(String sessionId) async {
    await _ensureConfig();
    if (_demo != null) return _demo!.restore();
    final res = await _api('/api/verify', {'sessionId': sessionId});
    final status = _statusFrom(res);
    final customerId = res['customerId'] as String?;
    if (customerId != null) saveCustomerId(customerId);
    _controller.add(status);
    return status;
  }

  @override
  Future<SubscriptionStatus> restore() async {
    await _ensureConfig();
    if (_demo != null) return _demo!.restore();
    final customerId = getCustomerId();
    if (customerId == null) return SubscriptionStatus.none;
    try {
      final res = await _api('/api/verify', {'customerId': customerId});
      return _statusFrom(res);
    } catch (_) {
      return SubscriptionStatus.none;
    }
  }

  static SubscriptionStatus _statusFrom(Map<String, dynamic> m) =>
      SubscriptionStatus(
        isActive: m['isActive'] == true,
        plan: switch (m['plan'] as String?) {
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
