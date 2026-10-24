/// Browser speech recognizer — Web Speech API (`SpeechRecognition`, or
/// `webkitSpeechRecognition` in Chrome/Safari). Firefox has neither, so
/// [isAvailable] is false there and stage 4 degrades as before.
///
/// Unlike the iOS recognizer this is NOT on-device: Chrome sends audio to
/// Google, Safari may use Apple's servers. The web privacy copy says so.
library;

import 'dart:async';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:js_util' as js_util;

import 'speech.dart';

SpeechRecognizer? createWebSpeechRecognizer() => WebSpeechRecognizer();

class WebSpeechRecognizer implements SpeechRecognizer {
  Object? _active;

  Object? get _ctor =>
      js_util.getProperty<Object?>(html.window, 'SpeechRecognition') ??
      js_util.getProperty<Object?>(html.window, 'webkitSpeechRecognition');

  @override
  Future<bool> isAvailable() async => _ctor != null;

  @override
  Future<bool> requestPermission() async {
    try {
      final stream = await html.window.navigator.mediaDevices!
          .getUserMedia({'audio': true});
      for (final t in stream.getTracks()) {
        t.stop(); // only needed the grant; recognition opens its own stream
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<RecognitionResult?> listen({
    Duration maxDuration = const Duration(seconds: 4),
    String locale = 'ko-KR',
  }) {
    final ctor = _ctor;
    if (ctor == null) return Future.value(null);
    final done = Completer<RecognitionResult?>();
    final rec = js_util.callConstructor<Object>(ctor, const []);
    _active = rec;
    js_util.setProperty(rec, 'lang', locale);
    js_util.setProperty(rec, 'interimResults', false);
    js_util.setProperty(rec, 'maxAlternatives', 1);

    void finish(RecognitionResult? r) {
      if (!done.isCompleted) done.complete(r);
    }

    js_util.setProperty(rec, 'onresult', js_util.allowInterop((Object e) {
      // e.results[0][0] → {transcript, confidence}
      final results = js_util.getProperty<Object>(e, 'results');
      final first = js_util.callMethod<Object>(results, 'item', [0]);
      final alt = js_util.callMethod<Object>(first, 'item', [0]);
      finish(RecognitionResult(
        transcript: js_util.getProperty<String?>(alt, 'transcript') ?? '',
        confidence:
            (js_util.getProperty<num?>(alt, 'confidence') ?? 0).toDouble(),
      ));
    }));
    // No speech, network or permission errors all end with "no result" —
    // the stage offers a retry.
    js_util.setProperty(
        rec, 'onerror', js_util.allowInterop((Object _) => finish(null)));
    js_util.setProperty(
        rec, 'onend', js_util.allowInterop((Object _) => finish(null)));

    final cap = Timer(maxDuration, () {
      // stop() still delivers a final result for speech heard so far.
      js_util.callMethod<void>(rec, 'stop', const []);
    });
    js_util.callMethod<void>(rec, 'start', const []);
    return done.future.whenComplete(() {
      cap.cancel();
      if (identical(_active, rec)) _active = null;
    });
  }

  @override
  Future<void> stop() async {
    final rec = _active;
    if (rec != null) js_util.callMethod<void>(rec, 'stop', const []);
  }
}
