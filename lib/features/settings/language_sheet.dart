/// Shared UI-language picker (onboarding hook page + settings).
library;

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../l10n/l10n.dart';
import '../../theme/hq_theme.dart';

/// Native name of the language the app is currently shown in.
String currentLanguageName(BuildContext context) {
  final code = codeFromLocale(Localizations.localeOf(context));
  return appLanguages.where((e) => e.$1 == code).firstOrNull?.$2 ?? 'English';
}

/// Bottom sheet listing every UI language. [includeFollowDevice] adds a
/// first "Device language" option that clears the override.
Future<void> showLanguageSheet(BuildContext context,
    {bool includeFollowDevice = false}) {
  final state = AppScope.of(context);
  final followsDevice = state.locale == null;
  final current = codeFromLocale(Localizations.localeOf(context));
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: HqColors.hanji,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (sheetContext) {
      final l = sheetContext.l;
      Widget option(String label, bool selected, VoidCallback onTap) =>
          ListTile(
            title: Text(label,
                style: TextStyle(
                    color: HqColors.ink,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500)),
            trailing: selected
                ? const Icon(Icons.check_rounded, color: HqColors.dancheongRed)
                : null,
            onTap: () {
              onTap();
              Navigator.of(sheetContext).pop();
            },
          );
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(l.onbChooseLanguage,
                    style: Theme.of(sheetContext).textTheme.titleMedium),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    if (includeFollowDevice)
                      option(l.languageFollowDevice, followsDevice,
                          () => state.setLocale(null)),
                    for (final (code, name) in appLanguages)
                      option(
                          name,
                          code == current &&
                              !(includeFollowDevice && followsDevice),
                          () => state.setLocale(localeFromCode(code))),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
