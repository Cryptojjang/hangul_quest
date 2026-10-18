/// Onboarding: hook → 7-day promise → notification opt-in. Skippable.
library;

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/data/curriculum.dart';
import '../../theme/hq_theme.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  final _startedAt = DateTime.now();
  int _page = 0;

  void _finish() {
    final state = AppScope.of(context);
    state.completeOnboarding(
        DateTime.now().difference(_startedAt).inSeconds);
    Navigator.of(context)
        .pushReplacement(HqPageRoute(page: const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text('Skip',
                    style: TextStyle(color: HqColors.inkSoft)),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (p) => setState(() => _page = p),
                children: const [
                  _HookPage(),
                  _PromisePage(),
                  _NotifPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _page ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _page
                              ? HqColors.dancheongRed
                              : HqColors.celadon,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  HqButton(
                    label: _page == 2 ? 'Get started' : 'Next',
                    expanded: true,
                    onPressed: () {
                      if (_page == 2) {
                        _finish();
                      } else {
                        _controller.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The same line in Korean, shown small under the English copy — a first
/// glimpse of the script, not something the learner must read yet.
class _KoreanEcho extends StatelessWidget {
  const _KoreanEcho(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: HqColors.dancheongRed));
  }
}

class _HookPage extends StatelessWidget {
  const _HookPage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('한', style: TextStyle(fontSize: 120, fontWeight: FontWeight.w800, color: HqColors.dancheongRed)),
          const SizedBox(height: 24),
          Text('Read the songs you love\nin their own letters',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text(
              "Hangul is the world's easiest script to learn — "
              'its letters snap together like blocks.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          const _KoreanEcho('좋아하는 노래 제목, 직접 읽어 보세요'),
        ],
      ),
    );
  }
}

class _PromisePage extends StatelessWidget {
  const _PromisePage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Read Hangul\nin 7 days',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 32, color: HqColors.dancheongBlue)),
          const SizedBox(height: 8),
          const _KoreanEcho('7일이면 한글을 읽습니다'),
          const SizedBox(height: 24),
          for (final day in sevenDayTracker)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: HqColors.obangYellow, shape: BoxShape.circle),
                    child: Text('${day.day}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(day.titleEn,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: HqColors.ink)),
                        Text(day.goalEn,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Text('Just play. We handle the rest.',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _NotifPage extends StatelessWidget {
  const _NotifPage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const HqIconTile(
              icon: Icons.local_fire_department_rounded,
              color: HqColors.obangYellow,
              size: 112),
          const SizedBox(height: 24),
          Text('5 minutes a day\nkeeps your streak alive',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text("Want a gentle evening reminder? It's optional.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          const _KoreanEcho('하루 5분, 스트릭을 지켜요'),
          const SizedBox(height: 24),
          HqButton(
            label: 'Allow reminders',
            color: HqColors.dancheongBlue,
            onPressed: () async {
              await AppScope.of(context).services.push.requestPermission();
            },
          ),
        ],
      ),
    );
  }
}
