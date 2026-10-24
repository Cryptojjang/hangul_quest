import 'package:flutter/material.dart';

import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'state/app_state.dart';
import 'theme/hq_theme.dart';

/// InheritedNotifier so widgets can read AppState without a DI package.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<AppScope>()!
      .notifier!;
}

class HangulQuestApp extends StatelessWidget {
  const HangulQuestApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: AnimatedBuilder(
        animation: state,
        builder: (context, _) => MaterialApp(
          title: 'Hangul Bricks',
          debugShowCheckedModeBanner: false,
          theme: HqTheme.light(),
          // The UI is designed for a phone column. On wide screens (desktop
          // web) keep it at phone width, centered, instead of stretching —
          // stretched grids push content below the fold.
          builder: (context, child) => ColoredBox(
            color: HqColors.hanji,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: child,
              ),
            ),
          ),
          home: state.progress.onboardingDone
              ? const HomeScreen()
              : const OnboardingScreen(),
        ),
      ),
    );
  }
}
