/// Release-path AudioAssetManager: plays bundled assets resolved through
/// assets/audio/manifest.json. Voice slots duck BGM; missing slots log and
/// stay silent (never crash). Swapping dev TTS → studio recordings is a
/// file replacement + manifest regen — zero code change.
library;

import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'audio_asset_manager.dart';

/// Thin playback seam so unit tests can verify resolution without an audio
/// device. Production uses [_AudioplayersBackend].
abstract class PlaybackBackend {
  Future<void> playAsset(String assetPath, {required double volume});
  Future<void> playLoop(String assetPath, {required double volume});
  Future<void> stopLoop();
  Future<void> setLoopVolume(double volume);
}

class _AudioplayersBackend implements PlaybackBackend {
  final AudioPlayer _bgm = AudioPlayer(playerId: 'hq_bgm')
    ..setReleaseMode(ReleaseMode.loop);

  /// One-shot players currently alive (disposed on completion).
  final Set<AudioPlayer> _live = {};

  /// The active voice line — a new voice interrupts it, SFX never do.
  AudioPlayer? _voiceNow;

  // audioplayers AssetSource paths are relative to the assets/ folder.
  String _src(String assetPath) => assetPath.replaceFirst('assets/', '');

  void _dispose(AudioPlayer p) {
    if (_live.remove(p)) {
      if (identical(_voiceNow, p)) _voiceNow = null;
      p.dispose();
    }
  }

  @override
  Future<void> playAsset(String assetPath, {required double volume}) async {
    // A FRESH player per playback: reusing one player with stop()/play()
    // accumulates state races on web (audioplayers) during rapid rounds —
    // the "sound stops working after a while" failure mode. One-shots are
    // immune, and SFX may overlap (tap + combo) by design.
    final isVoice = assetPath.contains('/voice/');
    if (isVoice) {
      // Only one voice line at a time.
      final old = _voiceNow;
      _voiceNow = null;
      if (old != null) {
        old.stop().then((_) => _dispose(old)).catchError((_) => _dispose(old));
      }
    }
    final p = AudioPlayer();
    _live.add(p);
    if (isVoice) _voiceNow = p;
    p.onPlayerComplete.listen((_) => _dispose(p), onError: (_) => _dispose(p));
    // Safety net for streams that never fire completion (seen on web).
    Future.delayed(const Duration(seconds: 12), () => _dispose(p));
    try {
      await p.play(AssetSource(_src(assetPath)), volume: volume);
    } catch (_) {
      _dispose(p); // a failed clip must never poison later playback
    }
  }

  @override
  Future<void> playLoop(String assetPath, {required double volume}) async {
    try {
      await _bgm.stop();
      await _bgm.play(AssetSource(_src(assetPath)), volume: volume);
    } catch (_) {}
  }

  @override
  Future<void> stopLoop() async {
    try {
      await _bgm.stop();
    } catch (_) {}
  }

  @override
  Future<void> setLoopVolume(double volume) async {
    try {
      await _bgm.setVolume(volume);
    } catch (_) {}
  }
}

class BundledAudioManager extends AudioAssetManager {
  BundledAudioManager({PlaybackBackend? backend})
      : _backend = backend ?? _AudioplayersBackend();

  final PlaybackBackend _backend;
  Map<String, String> _manifest = const {};
  bool _recording = false;
  String? _currentBgm;

  /// Loads assets/audio/manifest.json. Call once at startup; safe to call
  /// again after a hot reload.
  Future<void> init() async {
    try {
      final raw = await rootBundle.loadString('assets/audio/manifest.json');
      _manifest = Map<String, String>.from(jsonDecode(raw) as Map);
    } catch (e) {
      debugPrint('[audio] manifest missing — all slots silent ($e)');
      _manifest = const {};
    }
  }

  /// Test/debug hook: which asset a slot resolves to (null = silent).
  String? resolve(String slotId) => _manifest[slotId];

  /// Test hook: inject a manifest without going through rootBundle.
  @visibleForTesting
  void debugLoadManifest(Map<String, String> manifest) =>
      _manifest = manifest;

  @override
  Future<void> playSlot(String slotId) async {
    if (muted || _recording) return;
    final path = _manifest[slotId];
    if (path == null) {
      debugPrint('[audio] no asset for slot $slotId');
      return;
    }
    await _backend.playAsset(path, volume: sfxVolume);
  }

  @override
  Future<void> playVoice(String slotId) async {
    if (muted || _recording) return;
    final path = _manifest[slotId];
    if (path == null) {
      debugPrint('[audio] no asset for voice slot $slotId');
      return;
    }
    try {
      // Duck BGM while the voice line plays (sound spec §4).
      await _backend.setLoopVolume(bgmVolume * 0.2);
      await _backend.playAsset(path, volume: voiceVolume);
    } catch (e) {
      debugPrint('[audio] voice $slotId failed: $e');
    } finally {
      // Restore after a beat; voice clips are ≤2s.
      Future.delayed(const Duration(seconds: 2), () {
        if (!muted && !_recording) {
          _backend.setLoopVolume(bgmVolume);
        }
      });
    }
  }

  @override
  Future<void> playBgm(String slotId) async {
    if (muted || _recording) return;
    final path = _manifest[slotId];
    if (path == null) {
      debugPrint('[audio] no asset for bgm slot $slotId');
      return;
    }
    if (_currentBgm == slotId) return;
    _currentBgm = slotId;
    await _backend.playLoop(path, volume: bgmVolume);
  }

  @override
  Future<void> stopBgm() async {
    _currentBgm = null;
    await _backend.stopLoop();
  }

  @override
  Future<void> setRecordingMode(bool active) async {
    _recording = active;
    if (active) await _backend.stopLoop();
  }
}
