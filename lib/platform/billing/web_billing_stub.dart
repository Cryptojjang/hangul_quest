/// Non-web platforms never construct the web billing gateway.
library;

import 'billing.dart';

BillingGateway? createWebBillingGateway({
  required String? Function() getCustomerId,
  required void Function(String) saveCustomerId,
}) =>
    null;
