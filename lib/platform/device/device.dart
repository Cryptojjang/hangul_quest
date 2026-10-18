/// Haptics + push abstractions (spec §6). Small on purpose — only the seams
/// the spec names; no speculative abstraction beyond them.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Semantic haptic moments (design spec §3) — impls map them to platform
/// primitives, so tuning lives in one place.
enum HapticCue { light, medium, success, error }

abstract class HapticsDriver {
  Future<void> play(HapticCue cue);
}

class FlutterHaptics implements HapticsDriver {
  @override
  Future<void> play(HapticCue cue) async {
    switch (cue) {
      case HapticCue.light:
        await HapticFeedback.selectionClick();
      case HapticCue.medium:
        await HapticFeedback.mediumImpact();
      case HapticCue.success:
        await HapticFeedback.heavyImpact();
      case HapticCue.error:
        await HapticFeedback.vibrate();
    }
  }
}

class NoopHaptics implements HapticsDriver {
  @override
  Future<void> play(HapticCue cue) async {}
}

abstract class PushDriver {
  Future<bool> requestPermission();
  Future<void> scheduleStreakReminder({required DateTime at});
  Future<void> cancelAll();
}

/// v1: local notifications only (streak reminder). Remote push is out of
/// scope. Stubbed until the host module lands.
class LocalNotificationPush implements PushDriver {
  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> scheduleStreakReminder({required DateTime at}) async {
    debugPrint('[push] streak reminder scheduled for $at (stub)');
  }

  @override
  Future<void> cancelAll() async {}
}

class NoopPush implements PushDriver {
  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> scheduleStreakReminder({required DateTime at}) async {}

  @override
  Future<void> cancelAll() async {}
}
