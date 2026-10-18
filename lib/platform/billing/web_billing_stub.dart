/// Non-web platforms never construct the web billing gateway.
library;

import 'billing.dart';

BillingGateway? createWebBillingGateway({
  required String? Function() getCustomerId,
  required void Function(String) saveCustomerId,
}) =>
    null;

/// Checkout-return session id from the page URL (web only).
String? checkoutSessionFromUrl() => null;

void clearCheckoutUrl() {}

/// No-op off web; the web variant verifies the Stripe session.
Future<void> confirmPendingCheckout(
        BillingGateway gateway, String sessionId) async {}
