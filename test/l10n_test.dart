/// UI localization: every supported locale renders the home map, and the
/// settings language picker switches the app language live.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/l10n/l10n.dart';

import 'widget_smoke_test.dart' show pumpApp;

void main() {
  for (final locale in L10n.supportedLocales) {
    testWidgets('home renders in ${codeFromLocale(locale)}', (tester) async {
      final state = await pumpApp(tester);
      state.setLocale(locale);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(lookupL10n(locale).homeStages), findsOneWidget);
      expect(find.text(lookupL10n(locale).appName), findsOneWidget);
    });
  }

  testWidgets('onboarding language button switches to German',
      (tester) async {
    final state = await pumpApp(tester, onboarded: false);
    await tester.tap(find.byIcon(Icons.language_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Choose your language'), findsOneWidget);
    expect(find.text('Device language'), findsNothing);

    await tester.tap(find.text('Deutsch'));
    await tester.pumpAndSettle();
    expect(state.locale, const Locale('de'));
    final de = lookupL10n(const Locale('de'));
    expect(find.text(de.commonSkip), findsOneWidget);
    expect(find.text(de.onbHookTitle), findsOneWidget);
  });

  testWidgets('settings language picker switches to Japanese',
      (tester) async {
    final state = await pumpApp(tester);
    expect(find.text('Stages'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    expect(find.text('Choose your language'), findsOneWidget);
    expect(find.text('Device language'), findsOneWidget);

    await tester.tap(find.text('日本語'));
    await tester.pumpAndSettle();
    expect(state.locale, const Locale('ja'));

    final ja = lookupL10n(const Locale('ja'));
    expect(find.text(ja.settingsTitle), findsOneWidget);
    tester.state<NavigatorState>(find.byType(Navigator).first).pop();
    await tester.pumpAndSettle();
    expect(find.text(ja.homeStages), findsOneWidget);
    expect(find.text('Stages'), findsNothing);
  });
}
