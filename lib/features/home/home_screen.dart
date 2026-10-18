/// Home map: 7-day tracker, stage nodes, streak, daily challenge, league.
library;

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/data/curriculum.dart';
import '../../core/economy/content_gate.dart';
import '../../theme/hq_theme.dart';
import '../codex/codex_screen.dart';
import '../minilesson/mini_lesson_screen.dart';
import '../paywall/paywall_screen.dart';
import '../review/review_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final (trackerDay, trackerPct) = state.trackerNow();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('한글퀘스트',
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
                _StreakFlame(days: state.progress.streakDays),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: HqColors.inkSoft),
                  onPressed: () => Navigator.of(context)
                      .push(HqPageRoute(page: const SettingsScreen())),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _TrackerCard(day: trackerDay, pct: trackerPct),
            const SizedBox(height: 16),
            _DailyChallengeCard(onPlay: () => _openStage(
                context, StageId.jamoHunt,
                level: state.progress.cleared(StageId.jamoHunt.name) + 1)),
            const SizedBox(height: 16),
            Text('스테이지', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final stage in StageId.values) ...[
              _StageNode(stage: stage),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: HqCard(
                    onTap: () => Navigator.of(context)
                        .push(HqPageRoute(page: const CodexScreen())),
                    child: Column(
                      children: [
                        const HqIconTile(icon: Icons.menu_book_rounded),
                        const SizedBox(height: 4),
                        const Text('자모 도감',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        Text('${state.progress.codex.length} / 67 카드',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: HqCard(
                    onTap: () => _openReview(context),
                    child: Column(
                      children: [
                        const HqIconTile(icon: Icons.psychology_rounded),
                        const SizedBox(height: 4),
                        const Text('스마트 복습',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        Text(
                            state.isPremium
                                ? '무제한'
                                : '오늘 맛보기 ${state.entitlements.reviewTeasersUsedToday}/1',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _LeagueCard(xp: state.progress.xp),
          ],
        ),
      ),
    );
  }

  static void _openReview(BuildContext context) {
    final state = AppScope.of(context);
    // Consumes the daily teaser for free users; false → quota exhausted.
    if (state.startReviewSession()) {
      Navigator.of(context).push(HqPageRoute(page: const ReviewScreen()));
    } else {
      final decision = state.gate.canStartReview(state.entitlements);
      PaywallScreen.show(context,
          trigger: state.gate.paywallTriggerFor(decision.reason)!);
    }
  }

  static void _openStage(BuildContext context, StageId stage, {required int level}) {
    final state = AppScope.of(context);
    final levels = levelsFor(stage);
    final capped = level.clamp(1, levels.length);
    final decision = state.gate.canPlayLevel(state.entitlements, stage, capped);
    if (!decision.allowed) {
      final trigger = state.gate.paywallTriggerFor(decision.reason);
      if (trigger != null) {
        PaywallScreen.show(context, trigger: trigger);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('이 기기에서는 발음 도전을 지원하지 않아요')));
      }
      return;
    }
    Navigator.of(context).push(HqPageRoute(
        page: MiniLessonScreen(stage: stage, level: capped)));
  }
}

class _StreakFlame extends StatelessWidget {
  const _StreakFlame({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: HqColors.obangYellow.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded,
              size: 18, color: HqColors.obangYellow),
          const SizedBox(width: 2),
          Text('$days',
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: HqColors.ink)),
        ],
      ),
    );
  }
}

class _TrackerCard extends StatelessWidget {
  const _TrackerCard({required this.day, required this.pct});

  final TrackerDay day;
  final double pct;

  @override
  Widget build(BuildContext context) {
    return HqCard(
      color: HqColors.dancheongBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('7일 한글 완독 — DAY ${day.day}',
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2)),
          const SizedBox(height: 6),
          Text(day.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800)),
          Text(day.goal, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor:
                  const AlwaysStoppedAnimation(HqColors.obangYellow),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyChallengeCard extends StatelessWidget {
  const _DailyChallengeCard({required this.onPlay});

  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return HqCard(
      child: Row(
        children: [
          const HqIconTile(
              icon: Icons.bolt_rounded, color: HqColors.obangYellow),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('데일리 챌린지',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                Text('오늘의 믹스 라운드로 스트릭을 지켜요',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          HqButton(label: '도전', onPressed: onPlay),
        ],
      ),
    );
  }
}

class _StageNode extends StatelessWidget {
  const _StageNode({required this.stage});

  final StageId stage;

  static const _meta = {
    StageId.jamoHunt: (Icons.hearing_rounded, '자모 사냥', '발음 듣고 자모 맞히기'),
    StageId.blockBuilder: (Icons.extension_rounded, '글자 조립', '초성+중성+종성 퍼즐'),
    StageId.wordRush: (Icons.image_search_rounded, '단어 러시', '단어 읽고 이미지 매칭'),
    StageId.pronunciation: (Icons.mic_rounded, '발음 도전', '내 발음 채점받기'),
  };

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final (icon, title, subtitle) = _meta[stage]!;
    final levels = levelsFor(stage);
    final cleared = state.progress.cleared(stage.name);
    final nextLevel = (cleared + 1).clamp(1, levels.length);
    final decision =
        state.gate.canPlayLevel(state.entitlements, stage, nextLevel);
    final locked = !decision.allowed;
    final speechGone = decision.reason == LockReason.speechUnavailable;

    return HqCard(
      onTap: () => HomeScreen._openStage(context, stage, level: nextLevel),
      color: locked ? const Color(0xFFEFE9DC) : Colors.white,
      child: Row(
        children: [
          HqIconTile(
              icon: icon, color: locked ? HqColors.inkSoft : HqColors.ink),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  if (locked) ...[
                    const SizedBox(width: 6),
                    Icon(speechGone ? Icons.mic_off : Icons.lock,
                        size: 14, color: HqColors.inkSoft),
                  ],
                ]),
                Text(
                    speechGone
                        ? '이 기기에서 지원되지 않음'
                        : subtitle,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text('$cleared/${levels.length}',
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: HqColors.dancheongGreen)),
        ],
      ),
    );
  }
}

class _LeagueCard extends StatelessWidget {
  const _LeagueCard({required this.xp});

  final int xp;

  /// Local bot league (spec §3.3) — deterministic weekly rivals, no server.
  static const _bots = [
    ('Mina', 820), ('Jae', 640), ('Sky', 450), ('Yuna', 300), ('Leo', 150),
  ];

  @override
  Widget build(BuildContext context) {
    final rows = [..._bots, ('나', xp)]
      ..sort((a, b) => b.$2.compareTo(a.$2));
    return HqCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('주간 리그 — 청자 리그',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (var i = 0; i < rows.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  SizedBox(
                      width: 24,
                      child: Text('${i + 1}',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: i < 2
                                  ? HqColors.obangYellow
                                  : HqColors.inkSoft))),
                  Expanded(
                      child: Text(rows[i].$1,
                          style: TextStyle(
                              fontWeight: rows[i].$1 == '나'
                                  ? FontWeight.w800
                                  : FontWeight.w400))),
                  Text('${rows[i].$2} XP',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
