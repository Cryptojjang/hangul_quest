import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/core/data/content_keys.dart';
import 'package:hangul_quest/core/data/content_translations.g.dart';
import 'package:hangul_quest/l10n/l10n.dart';

void main() {
  final en = englishContent();

  test('content_en.json matches the data (re-run export_content_en)', () {
    final file = (jsonDecode(
            File('lib/l10n/content/content_en.json').readAsStringSync())
        as Map).cast<String, String>();
    expect(file, en);
  });

  test('every non-English UI language has a full content translation', () {
    for (final (code, _) in appLanguages.where((l) => l.$1 != 'en')) {
      final t = contentTranslations[code];
      expect(t, isNotNull, reason: code);
      expect(t!.keys.toSet(), en.keys.toSet(), reason: code);
      for (final v in t.values) {
        expect(v.trim(), isNotEmpty, reason: code);
      }
    }
  });

  test('lookup falls back to English for unknown locale or key', () {
    expect(ct('xx', 'lesson.intro.title', 'What is Hangul?'),
        'What is Hangul?');
    expect(ct('ja', 'no.such.key', 'fallback'), 'fallback');
    expect(ct('ja', 'lesson.intro.title', 'What is Hangul?'),
        isNot('What is Hangul?'));
  });
}
