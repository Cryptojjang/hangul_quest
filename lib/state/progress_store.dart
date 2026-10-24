/// Local-first progress persistence (spec §7).
///
/// One serializable state tree + updatedAt timestamp so a future cloud sync
/// adapter can diff/merge. The adapter itself is deliberately NOT built.
library;

import 'dart:convert';
import 'dart:io';

import '../core/adaptive/error_tracker.dart';
import '../core/srs/srs.dart';

/// Storage seam: in-memory for tests, file for devices. (This is part of the
/// named local-first requirement, not speculative abstraction.)
abstract class StorageDriver {
  Future<String?> read();
  Future<void> write(String data);
}

class InMemoryStorage implements StorageDriver {
  String? _data;

  @override
  Future<String?> read() async => _data;

  @override
  Future<void> write(String data) async => _data = data;
}

class FileStorage implements StorageDriver {
  FileStorage(this.path);

  final String path;

  @override
  Future<String?> read() async {
    final f = File(path);
    if (!await f.exists()) return null;
    return f.readAsString();
  }

  @override
  Future<void> write(String data) async {
    final f = File(path);
    await f.parent.create(recursive: true);
    await f.writeAsString(data);
  }
}

class ProgressState {
  ProgressState({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  bool onboardingDone = false;

  /// UI language picked by the player (e.g. "ja", "zh_TW"); null = follow
  /// the device language.
  String? localeCode;

  /// Web checkout restore token ("orderId:identifier", Lemon Squeezy; key
  /// name predates the switch from Stripe) — lets restore()
  /// re-verify the subscription without a login (web channel only).
  String? stripeCustomerId;

  /// stageId name → highest cleared level (0 = none).
  final Map<String, int> clearedLevels = {};

  /// jamo id → codex tier (1 = unlocked, 2 = mastered).
  final Map<String, int> codex = {};

  /// XP for level/badge/league.
  int xp = 0;

  int streakDays = 0;
  String? lastPlayedDate; // yyyy-mm-dd
  int reviewTeasersUsedToday = 0;
  String? teaserDate;

  final ErrorTracker errors = ErrorTracker();
  late final SrsScheduler srs = SrsScheduler(clock: _clock);

  DateTime updatedAt = DateTime.fromMillisecondsSinceEpoch(0);

  // -- streak ---------------------------------------------------------------

  String _today() {
    final now = _clock();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  /// Call on any completed round. Returns true if the streak grew today.
  bool touchStreak() {
    final today = _today();
    if (lastPlayedDate == today) return false;
    final yesterday = _clock().subtract(const Duration(days: 1));
    final yDate = '${yesterday.year.toString().padLeft(4, '0')}-'
        '${yesterday.month.toString().padLeft(2, '0')}-'
        '${yesterday.day.toString().padLeft(2, '0')}';
    if (lastPlayedDate == yDate) {
      streakDays += 1;
    } else {
      streakDays = 1; // broken (or first ever) — restart
    }
    lastPlayedDate = today;
    return true;
  }

  /// True when the player missed exactly one day — the streak-repair
  /// (premium perk / paywall trigger) window.
  bool get streakRepairable {
    if (lastPlayedDate == null) return false;
    final last = DateTime.parse(lastPlayedDate!);
    final today = DateTime.parse(_today());
    return today.difference(last).inDays == 2;
  }

  void repairStreak() {
    // Premium-only (ContentGate.canRepairStreak); bridges the gap day.
    streakDays += 1;
    lastPlayedDate = _today();
  }

  // -- review teaser --------------------------------------------------------

  int teasersUsedToday() {
    if (teaserDate != _today()) return 0;
    return reviewTeasersUsedToday;
  }

  void useTeaser() {
    final today = _today();
    if (teaserDate != today) {
      teaserDate = today;
      reviewTeasersUsedToday = 0;
    }
    reviewTeasersUsedToday += 1;
  }

  // -- levels / codex -------------------------------------------------------

  int cleared(String stageName) => clearedLevels[stageName] ?? 0;

  void markCleared(String stageName, int level) {
    if (level > cleared(stageName)) clearedLevels[stageName] = level;
  }

  /// Returns true if this unlocked a NEW codex card.
  bool unlockCodex(String jamoId) {
    if (codex.containsKey(jamoId)) return false;
    codex[jamoId] = 1;
    return true;
  }

  /// Returns true if the card was newly upgraded to mastered.
  bool masterCodex(String jamoId) {
    if ((codex[jamoId] ?? 0) >= 2) return false;
    codex[jamoId] = 2;
    return true;
  }

  // -- serialization --------------------------------------------------------

  Map<String, dynamic> toJson() => {
        'version': 1,
        'onboardingDone': onboardingDone,
        'localeCode': localeCode,
        'stripeCustomerId': stripeCustomerId,
        'clearedLevels': clearedLevels,
        'codex': codex,
        'xp': xp,
        'streakDays': streakDays,
        'lastPlayedDate': lastPlayedDate,
        'reviewTeasersUsedToday': reviewTeasersUsedToday,
        'teaserDate': teaserDate,
        'errors': errors.toJson(),
        'srs': srs.toJson(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  void loadJson(Map<String, dynamic> json) {
    onboardingDone = json['onboardingDone'] as bool? ?? false;
    localeCode = json['localeCode'] as String?;
    stripeCustomerId = json['stripeCustomerId'] as String?;
    clearedLevels
      ..clear()
      ..addAll(Map<String, int>.from(json['clearedLevels'] as Map? ?? {}));
    codex
      ..clear()
      ..addAll(Map<String, int>.from(json['codex'] as Map? ?? {}));
    xp = json['xp'] as int? ?? 0;
    streakDays = json['streakDays'] as int? ?? 0;
    lastPlayedDate = json['lastPlayedDate'] as String?;
    reviewTeasersUsedToday = json['reviewTeasersUsedToday'] as int? ?? 0;
    teaserDate = json['teaserDate'] as String?;
    errors.loadJson(Map<String, dynamic>.from(json['errors'] as Map? ?? {}));
    srs.loadJson(Map<String, dynamic>.from(json['srs'] as Map? ?? {}));
    updatedAt = DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }
}

class ProgressStore {
  ProgressStore(this._driver, {DateTime Function()? clock})
      : state = ProgressState(clock: clock ?? DateTime.now),
        _clock = clock ?? DateTime.now;

  final StorageDriver _driver;
  final DateTime Function() _clock;
  final ProgressState state;

  Future<void> load() async {
    final raw = await _driver.read();
    if (raw == null) return;
    try {
      state.loadJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupt local state: start fresh rather than crash. Cloud sync (later)
      // will be the real safety net.
    }
  }

  Future<void> save() async {
    state.updatedAt = _clock();
    await _driver.write(jsonEncode(state.toJson()));
  }
}
