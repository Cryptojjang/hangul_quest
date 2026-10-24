/// Speech recognition abstraction (spec §6) with graceful degradation.
///
/// iOS: on-device Speech framework via platform channel (stubbed here).
/// Web/unsupported: [UnsupportedSpeechRecognizer] reports unavailable and
/// stage 4 disables itself — no crash, no paywall on a broken feature.
library;

class RecognitionResult {
  const RecognitionResult({required this.transcript, required this.confidence});

  final String transcript;

  /// 0..1 recognizer confidence.
  final double confidence;
}

abstract class SpeechRecognizer {
  /// Cheap capability probe; UI calls this before showing stage 4 as playable.
  Future<bool> isAvailable();

  /// Requests mic + speech permissions. Returns false when denied — the app
  /// must keep working with stage 4 disabled (review checklist item).
  Future<bool> requestPermission();

  /// Records up to [maxDuration] and returns the best transcription.
  Future<RecognitionResult?> listen({
    Duration maxDuration = const Duration(seconds: 4),
    String locale = 'ko-KR',
  });

  Future<void> stop();
}

// IosSpeechRecognizer lives in ios_speech_recognizer.dart (platform-channel
// implementation over ios/Runner/SpeechChannel.swift).

/// Degraded environments (web build with poor quality, simulators, denied
/// permission): stage 4 shows "not supported on this device".
class UnsupportedSpeechRecognizer implements SpeechRecognizer {
  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<RecognitionResult?> listen({
    Duration maxDuration = const Duration(seconds: 4),
    String locale = 'ko-KR',
  }) async =>
      null;

  @override
  Future<void> stop() async {}
}

/// Deterministic fake for tests and the dev simulator: echoes a scripted
/// transcript so scoring UI can be exercised end-to-end.
class FakeSpeechRecognizer implements SpeechRecognizer {
  FakeSpeechRecognizer({this.scriptedTranscript = '', this.confidence = 0.9});

  String scriptedTranscript;
  double confidence;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<RecognitionResult?> listen({
    Duration maxDuration = const Duration(seconds: 4),
    String locale = 'ko-KR',
  }) async =>
      RecognitionResult(transcript: scriptedTranscript, confidence: confidence);

  @override
  Future<void> stop() async {}
}
