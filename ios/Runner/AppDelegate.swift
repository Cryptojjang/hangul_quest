import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let messenger = controller.binaryMessenger
      SpeechChannel.register(with: messenger)
      if #available(iOS 15.0, *) {
        BillingChannel.register(with: messenger)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
