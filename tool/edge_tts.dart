/// Neural-TTS placeholder synthesis via the Edge read-aloud endpoint
/// (ko-KR-SunHiNeural) — replaces the SAPI dev voices with near-studio
/// quality until real voice-actor recordings land. Slot ids are unchanged.
///
///   dart run tool/edge_tts.dart            # synth all jobs in tts_jobs.json
///   dart run tool/edge_tts.dart voice/jamo/c_giyeok   # single slot
// ignore_for_file: avoid_print
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

const _token = '6A5AA1D4EAFF4E9FB37E23D68491D6F4';
const _voice = 'ko-KR-SunHiNeural';
const _outputFormat = 'audio-24khz-96kbitrate-mono-mp3';

/// Sec-MS-GEC: SHA-256 of (Windows file time rounded to 5 min + token).
String _secMsGec() {
  final unixSeconds = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  var winTicks = (unixSeconds + 11644473600);
  winTicks -= winTicks % 300; // round down to 5-minute boundary
  final ticks = winTicks * 10000000; // seconds → 100ns ticks
  return sha256.convert(utf8.encode('$ticks$_token')).toString().toUpperCase();
}

String _ssml(String text, {String rate = '-10%'}) =>
    "<speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' "
    "xml:lang='ko-KR'><voice name='$_voice'><prosody rate='$rate' pitch='+0Hz'>"
    '${const HtmlEscape().convert(text)}'
    '</prosody></voice></speak>';

const _chromiumVersion = '143.0.3272.76';

Future<Uint8List> synthesize(String text, {String rate = '-10%'}) async {
  final gec = _secMsGec();
  final url =
      'wss://speech.platform.bing.com/consumer/speech/synthesize/readaloud/'
      'edge/v1?TrustedClientToken=$_token&Sec-MS-GEC=$gec'
      '&Sec-MS-GEC-Version=1-$_chromiumVersion'
      '&ConnectionId=${_requestId()}';

  final ws = await WebSocket.connect(url, headers: {
    'Pragma': 'no-cache',
    'Cache-Control': 'no-cache',
    'Origin': 'chrome-extension://jdiccldimpdaibmpdkjnbmckianbfold',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'en-US,en;q=0.9',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
        'AppleWebKit/537.36 (KHTML, like Gecko) '
        'Chrome/${_chromiumVersion.split('.').first}.0.0.0 Safari/537.36 '
        'Edg/${_chromiumVersion.split('.').first}.0.0.0',
  });

  final audio = BytesBuilder();
  final done = Completer<void>();
  final requestId = _requestId();

  ws.listen((message) {
    if (message is String) {
      if (message.contains('Path:turn.end')) {
        if (!done.isCompleted) done.complete();
      }
    } else if (message is List<int>) {
      final bytes = Uint8List.fromList(message);
      // Binary frame: 2-byte BE header length, then headers, then payload.
      final headerLen = (bytes[0] << 8) | bytes[1];
      final header = utf8.decode(bytes.sublist(2, 2 + headerLen));
      if (header.contains('Path:audio')) {
        audio.add(bytes.sublist(2 + headerLen));
      }
    }
  }, onError: (Object e) {
    if (!done.isCompleted) done.completeError(e);
  }, onDone: () {
    if (!done.isCompleted) done.complete();
  });

  final now = DateTime.now().toUtc().toIso8601String();
  ws.add('X-Timestamp:$now\r\n'
      'Content-Type:application/json; charset=utf-8\r\n'
      'Path:speech.config\r\n\r\n'
      '{"context":{"synthesis":{"audio":{"metadataoptions":'
      '{"sentenceBoundaryEnabled":"false","wordBoundaryEnabled":"false"},'
      '"outputFormat":"$_outputFormat"}}}}');
  ws.add('X-RequestId:$requestId\r\n'
      'X-Timestamp:$now\r\n'
      'Content-Type:application/ssml+xml\r\n'
      'Path:ssml\r\n\r\n'
      '${_ssml(text)}');

  await done.future.timeout(const Duration(seconds: 20));
  await ws.close();
  return audio.toBytes();
}

String _requestId() {
  final rng = Random.secure();
  return List.generate(32, (_) => '0123456789abcdef'[rng.nextInt(16)]).join();
}

/// Fallback: Google Translate TTS (no auth, decent ko quality, mp3).
Future<Uint8List> synthesizeGoogle(String text) async {
  final client = HttpClient();
  try {
    final uri = Uri.parse('https://translate.google.com/translate_tts'
        '?ie=UTF-8&tl=ko&client=tw-ob&q=${Uri.encodeComponent(text)}');
    final req = await client.getUrl(uri);
    req.headers.set('User-Agent',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');
    final res = await req.close();
    if (res.statusCode != 200) {
      throw HttpException('google tts HTTP ${res.statusCode}');
    }
    final bytes = BytesBuilder();
    await for (final chunk in res) {
      bytes.add(chunk);
    }
    return bytes.toBytes();
  } finally {
    client.close();
  }
}

Future<void> main(List<String> args) async {
  final jobs = (jsonDecode(File('tool/tts_jobs.json').readAsStringSync())
          as List)
      .cast<Map<String, dynamic>>()
      .where((j) => args.isEmpty || args.contains(j['slot']))
      .toList();
  print('synthesizing ${jobs.length} slots with $_voice…');

  var ok = 0, failed = 0, viaGoogle = 0;
  var edgeBlocked = false;
  for (final job in jobs) {
    final outPath =
        (job['file'] as String).replaceFirst(RegExp(r'\.wav$'), '.mp3');
    try {
      Uint8List bytes;
      if (edgeBlocked) {
        bytes = await synthesizeGoogle(job['text'] as String);
        viaGoogle++;
      } else {
        try {
          bytes = await synthesize(job['text'] as String);
        } on WebSocketException {
          edgeBlocked = true; // 403 etc — fall back for the whole run
          print('\nedge endpoint refused; falling back to Google TTS');
          bytes = await synthesizeGoogle(job['text'] as String);
          viaGoogle++;
        }
      }
      if (bytes.length < 1000) {
        throw StateError('suspiciously small (${bytes.length} bytes)');
      }
      final f = File(outPath);
      await f.parent.create(recursive: true);
      await f.writeAsBytes(bytes);
      // Remove the SAPI wav so the manifest picks up the neural mp3.
      final wav = File(job['file'] as String);
      if (wav.existsSync()) wav.deleteSync();
      ok++;
      stdout.write('.');
    } catch (e) {
      failed++;
      print('\nFAIL ${job['slot']}: $e');
    }
    // Gentle pacing — the fallback endpoint rate-limits bursts.
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }
  print('\ndone: $ok ok ($viaGoogle via google), $failed failed');
  if (failed > 0) exitCode = 1;
}
