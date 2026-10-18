/// Analytics event contract + local logger.
///
/// Event names/params mirror docs/PRODUCT_SPEC.md §5.4. A real vendor SDK
/// (or first-party pipeline) later implements [Analytics]; game code only
/// ever talks to the interface.
library;

abstract class Analytics {
  void logEvent(String name, [Map<String, Object?> params = const {}]);
}

/// Spec'd event names — use these constants, never raw strings.
class Events {
  static const onboardingComplete = 'onboarding_complete';
  static const sevenDayProgress = 'seven_day_progress';
  static const stageStart = 'stage_start';
  static const stageComplete = 'stage_complete';
  static const codexUnlock = 'codex_unlock';
  static const reviewTeaserUsed = 'review_teaser_used';
  static const paywallShown = 'paywall_shown';
  static const trialStart = 'trial_start';
  static const subscribe = 'subscribe';
  static const retentionReturn = 'retention_return';
}

/// Paywall trigger identifiers (spec §5.3).
class PaywallTriggers {
  static const stage2Lock = 'stage2_lock';
  static const pronunciationEntry = 'pronunciation_entry';
  static const reviewTeaserEnd = 'review_teaser_end';
  static const streakRepair = 'streak_repair';
}

/// Dev/default implementation: keeps an in-memory ring buffer and prints in
/// debug builds. Swapped for a vendor implementation at release.
class LocalAnalytics implements Analytics {
  final List<({String name, Map<String, Object?> params, DateTime at})> log =
      [];

  @override
  void logEvent(String name, [Map<String, Object?> params = const {}]) {
    log.add((name: name, params: params, at: DateTime.now()));
    if (log.length > 500) log.removeAt(0);
    assert(() {
      // ignore: avoid_print
      print('[analytics] $name $params');
      return true;
    }());
  }
}
