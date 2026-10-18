/// Web: persist the progress tree in localStorage so streaks, codex, and the
/// subscription cache survive reloads (path_provider has no web impl).
library;

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'progress_store.dart';

class _LocalStorageDriver implements StorageDriver {
  static const _key = 'hq_progress_v1';

  @override
  Future<String?> read() async => html.window.localStorage[_key];

  @override
  Future<void> write(String data) async =>
      html.window.localStorage[_key] = data;
}

StorageDriver? createWebStorage() => _LocalStorageDriver();
