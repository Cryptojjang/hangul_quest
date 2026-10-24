/// Home map: 7-day tracker, stage nodes, streak, daily challenge, league.
library;

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/data/curriculum.dart';
import '../../core/economy/content_gate.dart';
import '../../l10n/l10n.dart';
import '../../theme/hq_theme.dart';
import '../codex/codex_screen.dart';
import '../conversation/conversation_screen.dart';
import '../explore/explore_screen.dart';
import '../learn/learn_screen.dart';
import '../minilesson/mini_lesson_screen.dart';
import '../paywall/paywall_screen.dart';
import '../review/review_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l;
    final (trackerDay, trackerPct) = state.trackerNow();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l.appName,
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
                _StreakFlame(days: state.progress.streakDays),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.settings_outlined,
                      color: HqColors.inkSoft),
                  onPressed: () => Navigator.of(context)
                      .push(HqPageRoute(page: const SettingsScreen())),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _TrackerCard(day: trackerDay, pct: trackerPct),
            const SizedBox(height: 16),
            const _LearnCard(),
            const SizedBox(height: 10),
            const _TalkCard(),
            const SizedBox(height: 10),
            const _ExploreCard(),
            const SizedBox(height: 16),
            _DailyChallengeCard(
                onPlay: () => _openStage(context, StageId.jamoHunt,
                    level: state.progress.cleared(StageId.jamoHunt.name) + 1)),
            const SizedBox(height: 16),
            Text(l.homeStages, style: Theme.of(context).textTheme.titleMedium),
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
                        Text(l.homeCodex,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        Text(l.homeCodexCount(state.progress.codex.length),
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
                        Text(l.homeReview,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        Text(
                            state.isPremium
                                ? l.homeReviewUnlimited
                                : l.homeReviewFreeToday(state
                                    .entitlements.reviewTeasersUsedToday),
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

  static void _openStage(BuildContext context, StageId stage,
      {required int level}) {
    final state = AppScope.of(context);
    final levels = levelsFor(stage);
    final capped = level.clamp(1, levels.length);
    final decision = state.gate.canPlayLevel(state.entitlements, stage, capped);
    if (!decision.allowed) {
      final trigger = state.gate.paywallTriggerFor(decision.reason);
      if (trigger != null) {
        PaywallScreen.show(context, trigger: trigger);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l.homeSpeechUnsupported)));
      }
      return;
    }
    Navigator.of(context)
        .push(HqPageRoute(page: MiniLessonScreen(stage: stage, level: capped)));
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
    final l = context.l;
    return HqCard(
      color: HqColors.dancheongBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.trackerHeader(day.day),
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2)),
          const SizedBox(height: 6),
          Text(l.trackerTitle(day.day),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800)),
          Text(l.trackerGoal(day.day),
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(HqColors.obangYellow),
            ),
          ),
        ],
      ),
    );
  }
}

/// Home entry card: icon tile, title, subtitle, chevron.
class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.page,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return HqCard(
      onTap: () => Navigator.of(context).push(HqPageRoute(page: page)),
      child: Row(
        children: [
          HqIconTile(icon: icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: HqColors.inkSoft),
        ],
      ),
    );
  }
}

/// Entry to the free Learn Hangul course — placed above the stages so new
/// learners find the explanations before the games.
class _LearnCard extends StatelessWidget {
  const _LearnCard();

  @override
  Widget build(BuildContext context) => _EntryCard(
        icon: Icons.school_rounded,
        color: HqColors.dancheongBlue,
        title: context.l.homeLearnTitle,
        subtitle: context.l.homeLearnSubtitle,
        page: const LearnScreen(),
      );
}

/// Entry to the situational conversations (premium; first few free).
class _TalkCard extends StatelessWidget {
  const _TalkCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return _EntryCard(
      icon: Icons.forum_rounded,
      color: HqColors.dancheongRed,
      title: l.homeTalkTitle,
      subtitle: AppScope.of(context).isPremium
          ? l.homeTalkSubtitlePremium
          : l.homeTalkSubtitleFree,
      page: const ConversationListScreen(),
    );
  }
}

/// Entry to the free Explore Korea guide (apps, history, food, saju).
class _ExploreCard extends StatelessWidget {
  const _ExploreCard();

  @override
  Widget build(BuildContext context) => _EntryCard(
        icon: Icons.travel_explore_rounded,
        color: HqColors.dancheongGreen,
        title: context.l.homeExploreTitle,
        subtitle: context.l.homeExploreSubtitle,
        page: const ExploreScreen(),
      );
}

class _DailyChallengeCard extends StatelessWidget {
  const _DailyChallengeCard({required this.onPlay});

  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
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
                Text(l.homeDailyTitle,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(l.homeDailySubtitle,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          HqButton(label: l.commonGo, onPressed: onPlay),
        ],
      ),
    );
  }
}

class _StageNode extends StatelessWidget {
  const _StageNode({required this.stage});

  final StageId stage;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l;
    final (icon, title, subtitle) = switch (stage) {
      StageId.jamoHunt => (
          Icons.hearing_rounded,
          l.stageJamoHunt,
          l.stageJamoHuntSub
        ),
      StageId.blockBuilder => (
          Icons.extension_rounded,
          l.stageLetterBuilder,
          l.stageLetterBuilderSub
        ),
      StageId.wordRush => (
          Icons.image_search_rounded,
          l.stageWordRush,
          l.stageWordRushSub
        ),
      StageId.pronunciation => (
          Icons.mic_rounded,
          l.stagePronunciation,
          l.stagePronunciationSub
        ),
    };
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
                  Flexible(
                    child: Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  if (locked) ...[
                    const SizedBox(width: 6),
                    Icon(speechGone ? Icons.mic_off : Icons.lock,
                        size: 14, color: HqColors.inkSoft),
                  ],
                ]),
                Text(speechGone ? l.homeNotSupported : subtitle,
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
    ('Mina', 820),
    ('Jae', 640),
    ('Sky', 450),
    ('Yuna', 300),
    ('Leo', 150),
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    // Null name marks the player's own row (its label is localized).
    final rows = <(String?, int)>[..._bots, (null, xp)]
      ..sort((a, b) => b.$2.compareTo(a.$2));
    return HqCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.homeLeague,
              style: const TextStyle(fontWeight: FontWeight.w700)),
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
                      child: Text(rows[i].$1 ?? l.homeLeagueYou,
                          style: TextStyle(
                              fontWeight: rows[i].$1 == null
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
