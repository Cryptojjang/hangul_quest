/// Shared post-round result screen: stars, combo, wrong-answer recap,
/// codex unlock toasts, next-action CTA.
library;

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/data/curriculum.dart';
import '../../core/game/round_engine.dart';
import '../../core/hangul/hangul.dart';
import '../../platform/audio/audio_asset_manager.dart';
import '../../theme/hq_theme.dart';
import '../home/home_screen.dart';
import '../minilesson/mini_lesson_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.stage,
    required this.level,
    required this.score,
    required this.touchedJamoIds,
  });

  final StageId stage;
  final int level;
  final RoundScore score;
  final List<String> touchedJamoIds;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<String> _newCards = const [];
  bool _booked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_booked) return;
    _booked = true;
    final state = AppScope.of(context);
    // Book rewards after this frame: onStageComplete notifies listeners,
    // which must never happen during the build phase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cards = state.onStageComplete(
        stage: widget.stage,
        level: widget.level,
        stars: widget.score.stars,
        points: widget.score.points,
        mistakes: widget.score.wrong,
        touchedJamoIds: widget.touchedJamoIds,
      );
      state.services.audio.playSlot(AudioSlots.levelUp);
      setState(() => _newCards = cards);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final weakest = state.progress.errors.weakestItems(limit: 3);
    final levels = levelsFor(widget.stage);
    final hasNext = widget.level < levels.length;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final earned = i < widget.score.stars;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text('★',
                        style: TextStyle(
                            fontSize: 52,
                            color: earned
                                ? HqColors.obangYellow
                                : HqColors.celadon)),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text('+${widget.score.points} XP',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: HqColors.dancheongGreen)),
              Text('Best combo ${widget.score.maxCombo}',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 20),
              if (_newCards.isNotEmpty)
                HqCard(
                  color: HqColors.celadon.withValues(alpha: 0.4),
                  child: Row(
                    children: [
                      const HqIconTile(
                          icon: Icons.style_rounded, size: 40),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                            'New codex cards: ${_newCards.length} · '
                            '${_newCards.map((id) => jamoById[id]!.char).join(' ')}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              if (weakest.isNotEmpty) ...[
                const SizedBox(height: 12),
                HqCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sounds to review',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                          weakest
                              .map((id) => jamoById[id]?.char ?? id)
                              .join('  ·  '),
                          style: const TextStyle(
                              fontSize: 24, color: HqColors.dancheongRed)),
                      Text('Letters you miss will show up more often',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              if (hasNext)
                HqButton(
                  label: 'Next level',
                  expanded: true,
                  onPressed: () => Navigator.of(context).pushReplacement(
                      HqPageRoute(
                          page: MiniLessonScreen(
                              stage: widget.stage,
                              level: widget.level + 1))),
                ),
              const SizedBox(height: 8),
              HqButton(
                label: 'Back to map',
                color: Colors.white,
                textColor: HqColors.ink,
                expanded: true,
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    HqPageRoute(page: const HomeScreen()), (r) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
