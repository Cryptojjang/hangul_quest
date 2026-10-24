/// App UI languages. English is the source; the others target the biggest
/// Hallyu fan bases. Translations live in lib/l10n/app_*.arb and are
/// compiled by `flutter gen-l10n` (runs automatically on build/test).
library;

import 'package:flutter/widgets.dart';

import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

/// (locale code as stored, native name shown in the picker).
const List<(String, String)> appLanguages = [
  ('en', 'English'),
  ('ja', '日本語'),
  ('zh', '简体中文'),
  ('zh_TW', '繁體中文'),
  ('th', 'ไทย'),
  ('vi', 'Tiếng Việt'),
  ('id', 'Bahasa Indonesia'),
  ('es', 'Español'),
  ('pt', 'Português'),
  ('fr', 'Français'),
  ('de', 'Deutsch'),
];

Locale localeFromCode(String code) {
  final parts = code.split('_');
  return parts.length > 1 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
}

String codeFromLocale(Locale l) =>
    l.countryCode == null || l.countryCode!.isEmpty
        ? l.languageCode
        : '${l.languageCode}_${l.countryCode}';

/// Picks the best supported language for the device: Traditional Chinese
/// for TW/HK/MO/Hant, else the same language, else English.
Locale resolveAppLocale(Locale? device) {
  if (device == null) return const Locale('en');
  if (device.languageCode == 'zh') {
    final hant = device.scriptCode == 'Hant' ||
        const {'TW', 'HK', 'MO'}.contains(device.countryCode);
    return hant ? const Locale('zh', 'TW') : const Locale('zh');
  }
  final match = L10n.supportedLocales
      .where((l) => l.languageCode == device.languageCode)
      .firstOrNull;
  return match ?? const Locale('en');
}

extension L10nContext on BuildContext {
  L10n get l => L10n.of(this);
}

/// 7-day tracker copy by day number (shown on onboarding and home).
extension TrackerL10n on L10n {
  String trackerTitle(int day) => switch (day) {
        1 => trackerDay1Title,
        2 => trackerDay2Title,
        3 => trackerDay3Title,
        4 => trackerDay4Title,
        5 => trackerDay5Title,
        6 => trackerDay6Title,
        _ => trackerDay7Title,
      };

  String trackerGoal(int day) => switch (day) {
        1 => trackerDay1Goal,
        2 => trackerDay2Goal,
        3 => trackerDay3Goal,
        4 => trackerDay4Goal,
        5 => trackerDay5Goal,
        6 => trackerDay6Goal,
        _ => trackerDay7Goal,
      };
}
