/// Scans assets/images/** and writes assets/images/manifest.json mapping
/// illustration slot ids (e.g. img/word/kimchi) to asset paths. Run after
/// the art pipeline drops files:
///
///   dart run tool/gen_image_manifest.dart
// ignore_for_file: avoid_print
library;

import 'dart:convert';
import 'dart:io';

void main() {
  final root = Directory('assets/images');
  if (!root.existsSync()) {
    print('assets/images not found — nothing to do (emoji fallback active)');
    return;
  }
  final manifest = <String, String>{};
  for (final f in root.listSync(recursive: true).whereType<File>()) {
    final rel = f.path.replaceAll('\\', '/');
    if (rel.endsWith('manifest.json')) continue;
    final slot = 'img/${rel.substring('assets/images/'.length).replaceFirst(RegExp(r'\.(png|webp|jpg|svg)$'), '')}';
    manifest[slot] = rel;
  }
  File('assets/images/manifest.json').writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(manifest));
  print('wrote ${manifest.length} slots to assets/images/manifest.json');
}
