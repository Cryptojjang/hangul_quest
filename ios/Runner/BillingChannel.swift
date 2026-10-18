import Flutter
import StoreKit

/// StoreKit 2 bridge for subscriptions (hq_premium_monthly / hq_premium_yearly).
///
/// MethodChannel `hq/billing`:
///  - fetchProducts() -> [{id, plan, priceLabel, trialDays, savingsLabel?}]
///  - purchase(id: String) -> {success, isTrial, error?}
///  - restore() -> {isActive, plan?, inTrial, expiresAtMillis?}
///
/// EventChannel `hq/billing/status`: streams the same status map on every
/// Transaction.updates event (renewal, cancellation, revocation).
@available(iOS 15.0, *)
final class BillingChannel: NSObject, FlutterStreamHandler {
  static let productIds = ["hq_premium_yearly", "hq_premium_monthly"]

  private var updatesTask: Task<Void, Never>?
  private var eventSink: FlutterEventSink?

  static func register(with messenger: FlutterBinaryMessenger) {
    let instance = BillingChannel()
    let channel = FlutterMethodChannel(name: "hq/billing", binaryMessenger: messenger)
    channel.setMethodCallHandler(instance.handle)
    let events = FlutterEventChannel(name: "hq/billing/status", binaryMessenger: messenger)
    events.setStreamHandler(instance)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "fetchProducts":
      Task {
        do {
          let products = try await Product.products(for: Self.productIds)
          let payload: [[String: Any]] = products
            .sorted { $0.id == "hq_premium_yearly" && $1.id != "hq_premium_yearly" }
            .map { p in
              var m: [String: Any] = [
                "id": p.id,
                "plan": p.id.contains("yearly") ? "yearly" : "monthly",
                "priceLabel": p.displayPrice,
                "trialDays": Self.trialDays(of: p),
              ]
              if p.id.contains("yearly") { m["savingsLabel"] = "SAVE 52%" }
              return m
            }
          DispatchQueue.main.async { result(payload) }
        } catch {
          DispatchQueue.main.async {
            result(FlutterError(code: "fetch_failed", message: error.localizedDescription, details: nil))
          }
        }
      }

    case "purchase":
      let args = call.arguments as? [String: Any] ?? [:]
      guard let id = args["id"] as? String else {
        result(FlutterError(code: "bad_args", message: "missing product id", details: nil))
        return
      }
      Task {
        do {
          let products = try await Product.products(for: [id])
          guard let product = products.first else {
            DispatchQueue.main.async {
              result(["success": false, "isTrial": false, "error": "product not found"])
            }
            return
          }
          let outcome = try await product.purchase()
          switch outcome {
          case .success(let verification):
            switch verification {
            case .verified(let transaction):
              await transaction.finish()
              let trial = Self.trialDays(of: product) > 0
              DispatchQueue.main.async { result(["success": true, "isTrial": trial]) }
            case .unverified:
              DispatchQueue.main.async {
                result(["success": false, "isTrial": false, "error": "verification failed"])
              }
            }
          case .userCancelled:
            DispatchQueue.main.async {
              result(["success": false, "isTrial": false, "error": "cancelled"])
            }
          case .pending:
            DispatchQueue.main.async {
              result(["success": false, "isTrial": false, "error": "pending"])
            }
          @unknown default:
            DispatchQueue.main.async {
              result(["success": false, "isTrial": false, "error": "unknown"])
            }
          }
        } catch {
          DispatchQueue.main.async {
            result(["success": false, "isTrial": false, "error": error.localizedDescription])
          }
        }
      }

    case "restore":
      Task {
        let status = await Self.currentStatus()
        DispatchQueue.main.async { result(status) }
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Highest-value active entitlement among our subscription ids.
  static func currentStatus() async -> [String: Any] {
    for await entitlement in Transaction.currentEntitlements {
      guard case .verified(let t) = entitlement, productIds.contains(t.productID) else { continue }
      var m: [String: Any] = [
        "isActive": t.revocationDate == nil,
        "plan": t.productID.contains("yearly") ? "yearly" : "monthly",
        "inTrial": t.offerType == .introductory,
      ]
      if let exp = t.expirationDate {
        m["expiresAtMillis"] = Int(exp.timeIntervalSince1970 * 1000)
      }
      return m
    }
    return ["isActive": false, "inTrial": false]
  }

  static func trialDays(of product: Product) -> Int {
    guard let offer = product.subscription?.introductoryOffer,
          offer.paymentMode == .freeTrial else { return 0 }
    switch offer.period.unit {
    case .day: return offer.period.value
    case .week: return offer.period.value * 7
    case .month: return offer.period.value * 30
    case .year: return offer.period.value * 365
    @unknown default: return 0
    }
  }

  // MARK: - FlutterStreamHandler (hq/billing/status)

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    updatesTask = Task { [weak self] in
      for await _ in Transaction.updates {
        let status = await Self.currentStatus()
        DispatchQueue.main.async { self?.eventSink?(status) }
      }
    }
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    updatesTask?.cancel()
    updatesTask = nil
    eventSink = nil
    return nil
  }
}
