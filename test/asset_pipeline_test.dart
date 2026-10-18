/// Asset-pipeline integrity: every audio slot the game can request must
/// resolve in assets/audio/manifest.json (voice = dev TTS placeholders now,
/// studio recordings later — same slot ids). Runs against the real files on
/// disk so a missing/renamed asset fails CI, not a player's session.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/core/data/curriculum.dart';
import 'package:hangul_quest/core/data/vocab.dart';
import 'package:hangul_quest/core/hangul/hangul.dart';
import 'package:hangul_quest/platform/audio/audio_asset_manager.dart';
import 'package:hangul_quest/platform/audio/bundled_audio_manager.dart';

void main() {
  late Map<String, String> manifest;

  setUpAll(() {
    final raw = File('assets/audio/manifest.json').readAsStringSync();
    manifest = Map<String, String>.from(jsonDecode(raw) as Map);
  });

  test('every jamo voice slot has an asset', () {
    for (final j in jamoById.values) {
      expect(manifest, contains(AudioSlots.jamo(j)),
          reason: 'missing voice for ${j.char} (${j.id})');
    }
  });

  test('every stage-2 syllable target has a voice asset', () {
    for (final s in allStage2Targets()) {
      expect(manifest, contains(AudioSlots.syllable(s)),
          reason: 'missing voice for ${s.char}');
    }
  });

  test('every vocab word has a voice asset', () {
    for (final w in vocabWords) {
      expect(manifest, contains(AudioSlots.word(w.id)),
          reason: 'missing voice for ${w.korean}');
    }
  });

  test('vocab emoji stand-ins are unique — image matching stays unambiguous',
      () {
    final emoji = vocabWords.map((w) => w.emoji).toList();
    expect(emoji.toSet().length, emoji.length,
        reason: 'duplicate emoji make Word Rush answers indistinguishable');
  });

  test('every SFX slot the game triggers has an asset', () {
    final slots = [
      AudioSlots.tapCorrect,
      AudioSlots.tapWrong,
      AudioSlots.blockPick,
      AudioSlots.blockDrop,
      AudioSlots.blockReject,
      AudioSlots.syllableComplete,
      AudioSlots.levelUp,
      AudioSlots.cardUnlock,
      AudioSlots.streak,
      AudioSlots.countdown,
      AudioSlots.resultStar,
      AudioSlots.combo(2),
      AudioSlots.combo(3),
      AudioSlots.combo(4),
    ];
    for (final slot in slots) {
      expect(manifest, contains(slot), reason: 'missing sfx $slot');
    }
  });

  test('manifest paths point at real files', () {
    for (final e in manifest.entries) {
      expect(File(e.value).existsSync(), isTrue,
          reason: '${e.key} → ${e.value} does not exist');
    }
  });

  test('wav files are non-trivial (not empty/corrupt)', () {
    for (final e in manifest.entries) {
      final len = File(e.value).lengthSync();
      expect(len, greaterThan(1000),
          reason: '${e.key} suspiciously small ($len bytes)');
    }
  });

  group('BundledAudioManager', () {
    test('resolves known slots, silences unknown ones, ducks bgm on voice',
        () async {
      final backend = _FakeBackend();
      final audio = BundledAudioManager(backend: backend);
      // Inject the real on-disk manifest without rootBundle.
      audio.debugLoadManifest(manifest);

      await audio.playSlot(AudioSlots.tapCorrect);
      expect(backend.played.single, manifest[AudioSlots.tapCorrect]);

      await audio.playSlot('sfx/does_not_exist'); // must not throw
      expect(backend.played.length, 1);

      await audio.playBgm('bgm/home'); // no bgm assets yet → silent, no crash
      expect(backend.loops, isEmpty);

      final jamoSlot = AudioSlots.jamo(choseongTable.first);
      await audio.playVoice(jamoSlot);
      expect(backend.played.last, manifest[jamoSlot]);
      expect(backend.loopVolumes.last, lessThan(1.0),
          reason: 'voice playback must duck bgm');
    });

    test('recording mode mutes everything', () async {
      final backend = _FakeBackend();
      final audio = BundledAudioManager(backend: backend)
        ..debugLoadManifest(manifest);
      await audio.setRecordingMode(true);
      await audio.playSlot(AudioSlots.tapCorrect);
      await audio.playVoice(AudioSlots.jamo(choseongTable.first));
      expect(backend.played, isEmpty);
    });
  });
}

class _FakeBackend implements PlaybackBackend {
  final played = <String>[];
  final loops = <String>[];
  final loopVolumes = <double>[];

  @override
  Future<void> playAsset(String assetPath, {required double volume}) async =>
      played.add(assetPath);

  @override
  Future<void> playLoop(String assetPath, {required double volume}) async =>
      loops.add(assetPath);

  @override
  Future<void> stopLoop() async {}

  @override
  Future<void> setLoopVolume(double volume) async => loopVolumes.add(volume);
}
