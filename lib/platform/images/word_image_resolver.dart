/// Illustration pipeline hook for vocab words (docs/DESIGN_SPEC.md).
///
/// Art lands as files under assets/images/word/ + a manifest
/// (assets/images/manifest.json mapping imageSlot → asset path), regenerated
/// by tool/gen_image_manifest.dart. Until a slot has art, the UI falls back
/// to the category emoji — the game never blocks on the art pipeline.
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../core/data/vocab.dart';

class WordImageResolver {
  WordImageResolver._();

  static final WordImageResolver instance = WordImageResolver._();

  Map<String, String> _manifest = const {};

  Future<void> init() async {
    try {
      final raw = await rootBundle.loadString('assets/images/manifest.json');
      _manifest = Map<String, String>.from(jsonDecode(raw) as Map);
    } catch (_) {
      _manifest = const {}; // no art yet — emoji fallback everywhere
    }
    debugPrint('[images] ${_manifest.length} illustration slots resolved');
  }

  /// Asset path for the word's illustration, or null → use [emojiFor].
  String? resolve(VocabWord word) => _manifest[word.imageSlot];

  /// Per-word stand-in used until the slot's illustration exists — each word
  /// has a distinct emoji so image-matching stays playable in dev builds.
  static String emojiFor(VocabWord w) => w.emoji;

  @visibleForTesting
  void debugSetManifest(Map<String, String> manifest) =>
      _manifest = manifest;
}
