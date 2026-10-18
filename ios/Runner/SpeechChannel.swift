import Flutter
import Speech
import AVFoundation

/// MethodChannel bridge for on-device Korean speech recognition (stage 4).
///
/// Channel: `hq/speech`
///  - isAvailable() -> Bool
///  - requestPermission() -> Bool
///  - listen(maxSeconds: Double, locale: String) -> {transcript, confidence}?
///  - stop() -> nil
///
/// Privacy contract (matches NSMicrophoneUsageDescription): recognition is
/// forced on-device; audio is never stored or transmitted.
final class SpeechChannel: NSObject {
  private let audioEngine = AVAudioEngine()
  private var recognizer: SFSpeechRecognizer?
  private var request: SFSpeechAudioBufferRecognitionRequest?
  private var task: SFSpeechRecognitionTask?
  private var pendingResult: FlutterResult?
  private var timeoutTimer: Timer?

  static func register(with messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "hq/speech", binaryMessenger: messenger)
    let instance = SpeechChannel()
    channel.setMethodCallHandler(instance.handle)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isAvailable":
      let r = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
      if #available(iOS 13.0, *) {
        result((r?.isAvailable ?? false) && (r?.supportsOnDeviceRecognition ?? false))
      } else {
        result(false)
      }

    case "requestPermission":
      SFSpeechRecognizer.requestAuthorization { auth in
        AVAudioSession.sharedInstance().requestRecordPermission { mic in
          DispatchQueue.main.async {
            result(auth == .authorized && mic)
          }
        }
      }

    case "listen":
      let args = call.arguments as? [String: Any] ?? [:]
      let maxSeconds = args["maxSeconds"] as? Double ?? 4.0
      let locale = args["locale"] as? String ?? "ko-KR"
      startListening(maxSeconds: maxSeconds, locale: locale, result: result)

    case "stop":
      finish(with: nil)
      result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func startListening(maxSeconds: Double, locale: String, result: @escaping FlutterResult) {
    guard pendingResult == nil else {
      result(FlutterError(code: "busy", message: "already listening", details: nil))
      return
    }
    recognizer = SFSpeechRecognizer(locale: Locale(identifier: locale))
    guard let recognizer = recognizer, recognizer.isAvailable else {
      result(nil)
      return
    }
    pendingResult = result

    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.record, mode: .measurement, options: .duckOthers)
      try session.setActive(true, options: .notifyOthersOnDeactivation)

      let req = SFSpeechAudioBufferRecognitionRequest()
      req.shouldReportPartialResults = false
      if #available(iOS 13.0, *) {
        req.requiresOnDeviceRecognition = true  // privacy contract
      }
      request = req

      let input = audioEngine.inputNode
      let format = input.outputFormat(forBus: 0)
      input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
        req.append(buffer)
      }
      audioEngine.prepare()
      try audioEngine.start()

      task = recognizer.recognitionTask(with: req) { [weak self] res, err in
        guard let self = self else { return }
        if let res = res, res.isFinal {
          let best = res.bestTranscription
          let confidence = best.segments.isEmpty
            ? 0.0
            : best.segments.map { Double($0.confidence) }.reduce(0, +) / Double(best.segments.count)
          self.finish(with: ["transcript": best.formattedString, "confidence": confidence])
        } else if err != nil {
          self.finish(with: nil)
        }
      }

      timeoutTimer = Timer.scheduledTimer(withTimeInterval: maxSeconds, repeats: false) { [weak self] _ in
        self?.request?.endAudio()  // force a final result
      }
    } catch {
      finish(with: nil)
    }
  }

  private func finish(with payload: [String: Any]?) {
    timeoutTimer?.invalidate()
    timeoutTimer = nil
    if audioEngine.isRunning {
      audioEngine.stop()
      audioEngine.inputNode.removeTap(onBus: 0)
    }
    task?.cancel()
    task = nil
    request = nil
    try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    pendingResult?(payload)
    pendingResult = nil
  }
}
