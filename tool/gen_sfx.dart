/// Procedural SFX synthesis (docs/SOUND_SPEC.md §2) — richer, game-feel
/// versions of the placeholder tones: bell-timbre chimes for success,
/// harmonic buzzers for errors. Same slot names; studio SFX replace 1:1.
///
///   dart run tool/gen_sfx.dart
// ignore_for_file: avoid_print
library;

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

const _rate = 22050;

/// Bell-ish partials: fundamental + softened 2nd/3rd harmonics.
double _bell(double f, double t) =>
    sin(2 * pi * f * t) +
    0.45 * sin(2 * pi * f * 2 * t) +
    0.18 * sin(2 * pi * f * 3 * t);

/// Buzzer: odd harmonics approximate a square wave — harsh on purpose.
double _buzz(double f, double t) =>
    sin(2 * pi * f * t) +
    0.55 * sin(2 * pi * f * 3 * t) +
    0.30 * sin(2 * pi * f * 5 * t) +
    0.18 * sin(2 * pi * f * 7 * t);

class _Track {
  final List<double> samples = [];

  int get length => samples.length;

  void _ensure(int end) {
    while (samples.length < end) {
      samples.add(0);
    }
  }

  /// Mixes a tone starting at [at] seconds.
  void tone(
    double freq, {
    required double at,
    required double dur,
    double gain = 0.5,
    double Function(double f, double t) timbre = _bell,
    double glideTo = 0,
    double attack = 0.005,
  }) {
    final start = (at * _rate).round();
    final n = (dur * _rate).round();
    _ensure(start + n);
    for (var i = 0; i < n; i++) {
      final t = i / _rate;
      final progress = i / n;
      final f = glideTo == 0 ? freq : freq + (glideTo - freq) * progress;
      final env = (t < attack ? t / attack : 1.0) *
          exp(-5.0 * progress); // pluck envelope
      samples[start + i] += timbre(f, t) * gain * env;
    }
  }

  /// White-noise sparkle burst (card unlock shimmer).
  void sparkle({required double at, required double dur, double gain = 0.15}) {
    final rng = Random(42);
    final start = (at * _rate).round();
    final n = (dur * _rate).round();
    _ensure(start + n);
    double lp = 0;
    for (var i = 0; i < n; i++) {
      final progress = i / n;
      lp = lp * 0.6 + (rng.nextDouble() * 2 - 1) * 0.4; // soften the noise
      samples[start + i] += lp * gain * exp(-3.0 * progress);
    }
  }

  void write(String path) {
    final n = samples.length;
    final pcm = Int16List(n);
    for (var i = 0; i < n; i++) {
      pcm[i] = (samples[i].clamp(-1.0, 1.0) * 32767 * 0.85).round();
    }
    final data = pcm.buffer.asUint8List();
    final b = BytesBuilder()
      ..add('RIFF'.codeUnits)
      ..add(_u32(36 + data.length))
      ..add('WAVEfmt '.codeUnits)
      ..add(_u32(16))
      ..add(_u16(1))
      ..add(_u16(1))
      ..add(_u32(_rate))
      ..add(_u32(_rate * 2))
      ..add(_u16(2))
      ..add(_u16(16))
      ..add('data'.codeUnits)
      ..add(_u32(data.length))
      ..add(data);
    File(path)
      ..parent.createSync(recursive: true)
      ..writeAsBytesSync(b.toBytes());
    print('  ${path.split(RegExp(r'[/\\]')).last} (${n / _rate}s)');
  }

  static Uint8List _u32(int v) =>
      Uint8List(4)..buffer.asByteData().setUint32(0, v, Endian.little);
  static Uint8List _u16(int v) =>
      Uint8List(2)..buffer.asByteData().setUint16(0, v, Endian.little);
}

// Note frequencies.
const c5 = 523.25, e5 = 659.25, g5 = 783.99, a4 = 440.0;
const c6 = 1046.5, e6 = 1318.5, g6 = 1568.0, c7 = 2093.0, e7 = 2637.0;

void main() {
  const out = 'assets/audio/sfx';
  print('synthesizing sfx…');

  // 정답: 밝은 2음 상행 차임 — 짧지만 명확한 "딩동↑".
  _Track()
    ..tone(e6, at: 0, dur: 0.16, gain: 0.55)
    ..tone(g6, at: 0.07, dur: 0.30, gain: 0.5)
    ..write('$out/tap_correct.wav');

  // 오답: 하행 2음 버저 — 낮고 거칠게, 오해 여지 없는 "부부-".
  _Track()
    ..tone(220, at: 0, dur: 0.16, gain: 0.42, timbre: _buzz, glideTo: 185)
    ..tone(165, at: 0.16, dur: 0.30, gain: 0.45, timbre: _buzz, glideTo: 140)
    ..write('$out/tap_wrong.wav');

  // 콤보: 티어가 오를수록 높고 화려한 아르페지오.
  _Track()
    ..tone(c6, at: 0, dur: 0.12, gain: 0.45)
    ..tone(e6, at: 0.06, dur: 0.12, gain: 0.45)
    ..tone(g6, at: 0.12, dur: 0.25, gain: 0.45)
    ..write('$out/combo_2.wav');
  _Track()
    ..tone(e6, at: 0, dur: 0.12, gain: 0.45)
    ..tone(g6, at: 0.06, dur: 0.12, gain: 0.45)
    ..tone(c7, at: 0.12, dur: 0.28, gain: 0.45)
    ..write('$out/combo_3.wav');
  _Track()
    ..tone(g6, at: 0, dur: 0.12, gain: 0.45)
    ..tone(c7, at: 0.06, dur: 0.12, gain: 0.45)
    ..tone(e7, at: 0.12, dur: 0.32, gain: 0.45)
    ..sparkle(at: 0.12, dur: 0.3, gain: 0.08)
    ..write('$out/combo_4.wav');

  // 블록 픽업/장착/거부.
  _Track()
    ..tone(900, at: 0, dur: 0.05, gain: 0.35)
    ..write('$out/block_pick.wav');
  _Track()
    ..tone(520, at: 0, dur: 0.09, gain: 0.5, glideTo: 340)
    ..write('$out/block_drop.wav');
  _Track()
    ..tone(150, at: 0, dur: 0.11, gain: 0.42, timbre: _buzz)
    ..tone(150, at: 0.17, dur: 0.14, gain: 0.42, timbre: _buzz)
    ..write('$out/block_reject.wav');

  // 음절 완성: 장조 아르페지오 + 여운 — 완성의 쾌감.
  _Track()
    ..tone(c5, at: 0, dur: 0.14, gain: 0.42)
    ..tone(e5, at: 0.08, dur: 0.14, gain: 0.42)
    ..tone(g5, at: 0.16, dur: 0.16, gain: 0.42)
    ..tone(c6, at: 0.24, dur: 0.45, gain: 0.5)
    ..write('$out/syllable_complete.wav');

  // 레벨업 팡파레.
  _Track()
    ..tone(c5, at: 0, dur: 0.15, gain: 0.42)
    ..tone(g5, at: 0.12, dur: 0.15, gain: 0.42)
    ..tone(c6, at: 0.24, dur: 0.16, gain: 0.46)
    ..tone(e6, at: 0.36, dur: 0.18, gain: 0.46)
    ..tone(g6, at: 0.48, dur: 0.5, gain: 0.5)
    ..sparkle(at: 0.48, dur: 0.45, gain: 0.1)
    ..write('$out/level_up.wav');

  // 카드 해금: 상행 글리산도 + 샤인.
  _Track()
    ..tone(800, at: 0, dur: 0.4, gain: 0.35, glideTo: 2400)
    ..tone(c7, at: 0.35, dur: 0.35, gain: 0.4)
    ..sparkle(at: 0.3, dur: 0.4, gain: 0.12)
    ..write('$out/card_unlock.wav');

  // 스트릭: 따뜻한 상행 5도.
  _Track()
    ..tone(a4, at: 0, dur: 0.16, gain: 0.45)
    ..tone(e5, at: 0.1, dur: 0.35, gain: 0.48)
    ..write('$out/streak.wav');

  // 카운트다운 틱.
  _Track()
    ..tone(1000, at: 0, dur: 0.05, gain: 0.4)
    ..write('$out/countdown.wav');

  // 결과 별.
  _Track()
    ..tone(c7, at: 0, dur: 0.32, gain: 0.5)
    ..sparkle(at: 0, dur: 0.25, gain: 0.07)
    ..write('$out/result_star.wav');

  print('done');
}
