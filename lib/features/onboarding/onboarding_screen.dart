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
                child: const Text('건너뛰기',
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
                    label: _page == 2 ? '시작하기' : '다음',
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
          Text('좋아하는 그 노래 제목,\n직접 읽고 싶지 않나요?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text('한글은 세상에서 가장 배우기 쉬운 문자예요.\n블록처럼 조립되거든요.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall),
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
          Text('7일이면\n한글을 읽습니다',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 32, color: HqColors.dancheongBlue)),
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
                      child: Text('${day.title} — ${day.goal}',
                          style: Theme.of(context).textTheme.bodySmall)),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Text('게임만 하세요. 나머지는 저희가 할게요.',
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
          Text('하루 5분, 스트릭을 지켜요',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text('원하시면 매일 저녁 살짝 알려드릴게요.\n(선택 사항이에요)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 24),
          HqButton(
            label: '알림 허용',
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
