/// Scans assets/audio/** and writes assets/audio/manifest.json mapping
/// slot ids to asset paths. Run after adding/replacing audio files:
///
///   dart run tool/gen_audio_manifest.dart
// ignore_for_file: avoid_print
library;

import 'dart:convert';
import 'dart:io';

void main() {
  final root = Directory('assets/audio');
  if (!root.existsSync()) {
    stderr.writeln('assets/audio not found — run from the project root');
    exit(1);
  }
  final manifest = <String, String>{};
  for (final f in root.listSync(recursive: true).whereType<File>()) {
    final rel = f.path.replaceAll('\\', '/');
    if (rel.endsWith('manifest.json')) continue;
    final slot = rel
        .substring('assets/audio/'.length)
        .replaceFirst(RegExp(r'\.(wav|mp3|m4a|ogg)$'), '');
    manifest[slot] = rel;
  }
  final out = File('assets/audio/manifest.json');
  out.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(manifest));
  print('wrote ${manifest.length} slots to ${out.path}');
}
