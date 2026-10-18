/// iOS Speech framework recognizer — Dart side of the `hq/speech` channel
/// (host: ios/Runner/SpeechChannel.swift). On-device recognition only, per
/// the privacy copy in Info.plist.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'speech.dart';

class IosSpeechRecognizer implements SpeechRecognizer {
  IosSpeechRecognizer({@visibleForTesting MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('hq/speech');

  final MethodChannel _channel;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _channel.invokeMethod<bool>('isAvailable') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false; // non-iOS host → stage 4 degrades gracefully
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      return await _channel.invokeMethod<bool>('requestPermission') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<RecognitionResult?> listen({
    Duration maxDuration = const Duration(seconds: 4),
    String locale = 'ko-KR',
  }) async {
    try {
      final m = await _channel.invokeMapMethod<dynamic, dynamic>('listen', {
        'maxSeconds': maxDuration.inMilliseconds / 1000.0,
        'locale': locale,
      });
      if (m == null) return null;
      return RecognitionResult(
        transcript: m['transcript'] as String? ?? '',
        confidence: (m['confidence'] as num?)?.toDouble() ?? 0.0,
      );
    } on PlatformException {
      return null; // busy / audio session failure → UI offers retry
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _channel.invokeMethod<void>('stop');
    } on PlatformException {
      // already stopped
    }
  }
}
