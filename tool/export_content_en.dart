/// Writes lib/l10n/content/content_en.json — every translatable Learn and
/// Explore string, keyed. Translators translate this file per locale.
///
///   dart run tool/export_content_en.dart
// ignore_for_file: avoid_relative_lib_imports, avoid_print
library;

import 'dart:convert';
import 'dart:io';

import '../lib/core/data/content_keys.dart';

void main() {
  final en = englishContent();
  final out = File('lib/l10n/content/content_en.json');
  out.parent.createSync(recursive: true);
  out.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(en)}\n');
  print('wrote ${en.length} strings to ${out.path}');
}
