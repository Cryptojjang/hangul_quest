/// Non-web platforms: no browser localStorage. main() falls back to
/// file/in-memory storage.
library;

import 'progress_store.dart';

StorageDriver? createWebStorage() => null;
