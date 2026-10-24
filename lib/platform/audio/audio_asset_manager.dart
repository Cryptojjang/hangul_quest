/// Audio asset manager — the swappable audio seam (docs/SOUND_SPEC.md).
///
/// All playback goes through logical slot ids (`voice/jamo/c_giyeok`,
/// `sfx/combo_2`, `bgm/stage2`). Dev builds resolve voice slots to a TTS
/// placeholder; release resolves to studio recordings. Missing slots are
/// silent + logged, never a crash.
library;

import 'package:flutter/foundation.dart';

import '../../core/hangul/hangul.dart';

abstract class AudioAssetManager {
  Future<void> playSlot(String slotId);
  Future<void> playBgm(String slotId);
  Future<void> stopBgm();

  /// Ducks BGM while a voice slot plays (sound spec §4).
  Future<void> playVoice(String slotId);

  /// Mutes everything except the mic path during stage-4 recording.
  Future<void> setRecordingMode(bool active);

  double bgmVolume = 1.0;
  double sfxVolume = 1.0;
  double voiceVolume = 1.0;
  bool muted = false;
}

/// Slot id helpers so call sites never build strings by hand.
class AudioSlots {
  static String jamo(Jamo j) => 'voice/jamo/${j.id}';
  static String syllable(Syllable s) => 'voice/syllable/${s.codePoint}';
  static String word(String wordId) => 'voice/word/$wordId';
  static String phrase(String slotId) => 'voice/phrase/$slotId';

  static const tapCorrect = 'sfx/tap_correct';
  static const tapWrong = 'sfx/tap_wrong';
  static const blockPick = 'sfx/block_pick';
  static const blockDrop = 'sfx/block_drop';
  static const blockReject = 'sfx/block_reject';
  static const syllableComplete = 'sfx/syllable_complete';
  static const levelUp = 'sfx/level_up';
  static const cardUnlock = 'sfx/card_unlock';
  static const streak = 'sfx/streak';
  static const countdown = 'sfx/countdown';
  static const resultStar = 'sfx/result_star';
  static String combo(int tier) => 'sfx/combo_${tier.clamp(2, 4)}';
}

/// Dev implementation: logs playback and speaks voice slots through the
/// platform TTS placeholder when available. The release implementation maps
/// slots to bundled studio files with identical ids — zero call-site change.
class DevAudioManager extends AudioAssetManager {
  final List<String> playedLog = [];
  bool _recording = false;

  @override
  Future<void> playSlot(String slotId) async {
    if (muted || _recording) return;
    playedLog.add(slotId);
    debugPrint('[audio] $slotId');
  }

  @override
  Future<void> playVoice(String slotId) async {
    if (muted || _recording) return;
    playedLog.add(slotId);
    // TODO(dev): AVSpeechSynthesizer(ko-KR) placeholder via channel; slot ids
    // are 1:1 with studio recordings so release swaps assets, not code.
    debugPrint('[audio/voice+duck] $slotId');
  }

  @override
  Future<void> playBgm(String slotId) async {
    if (muted || _recording) return;
    debugPrint('[audio/bgm] $slotId');
  }

  @override
  Future<void> stopBgm() async {}

  @override
  Future<void> setRecordingMode(bool active) async {
    _recording = active;
  }
}
