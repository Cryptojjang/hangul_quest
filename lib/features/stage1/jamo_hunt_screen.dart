/// Stage 1 — Jamo Hunt: hear a native pronunciation, tap the matching jamo.
/// Combo, per-question timer, particles, and unmistakable answer feedback:
/// correct = green pop + flash + floating score; wrong = red shake + the
/// right answer revealed before the next question.
library;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/data/curriculum.dart';
import '../../core/game/round_engine.dart';
import '../../core/hangul/hangul.dart';
import '../../platform/audio/audio_asset_manager.dart';
import '../../platform/device/device.dart';
import '../../theme/feedback_fx.dart';
import '../../theme/hq_theme.dart';
import '../results/result_screen.dart';

class JamoHuntScreen extends StatefulWidget {
  const JamoHuntScreen({super.key, required this.level});

  final int level;

  @override
  State<JamoHuntScreen> createState() => _JamoHuntScreenState();
}

class _JamoHuntScreenState extends State<JamoHuntScreen>
    with SingleTickerProviderStateMixin {
  JamoHuntRound? _round;
  Timer? _ticker;
  Timer? _lead;
  double _secondsLeft = JamoHuntRound.questionSeconds.toDouble();

  /// Question currently ON SCREEN — kept during the feedback pause even
  /// though the round engine has already advanced.
  JamoHuntQuestion? _displayQ;

  /// Per-jamo feedback state during the answer pause.
  final Map<String, TileFeedback> _feedback = {};
  bool _answered = false;

  final _fx = GlobalKey<FeedbackFxState>();
  late final AnimationController _particles = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_round != null) return;
    final state = AppScope.of(context);
    _round = JamoHuntRound(
      level: stage1Levels[widget.level - 1],
      tracker: state.progress.errors,
    );
    _startQuestion(firstOfRound: true);
  }

  void _startQuestion({bool firstOfRound = false}) {
    _displayQ = _round!.current;
    _feedback.clear();
    _answered = false;
    _secondsLeft = JamoHuntRound.questionSeconds.toDouble();
    _ticker?.cancel();
    _lead?.cancel();
    // Lead-in before the prompt: the round's first question waits for the
    // page transition to land so the audio is never swallowed; later
    // questions get a short breath. The answer timer only starts WITH the
    // prompt, so the wait costs the player nothing.
    _lead = Timer(Duration(milliseconds: firstOfRound ? 550 : 150), () {
      if (!mounted) return;
      _playPrompt();
      _startTicker();
    });
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() => _secondsLeft -= 0.1);
      if (_secondsLeft <= 0) {
        _timeout();
      } else if (_secondsLeft <= 3.05 && _secondsLeft > 2.95) {
        AppScope.of(context).services.audio.playSlot(AudioSlots.countdown);
      }
    });
  }

  void _playPrompt() {
    final q = _displayQ;
    if (q != null) AppScope.of(context).playJamo(q.answer);
  }

  void _timeout() {
    if (_answered) return;
    final state = AppScope.of(context);
    final q = _displayQ!;
    _round!.timeout(tracker: state.progress.errors);
    state.services.audio.playSlot(AudioSlots.tapWrong);
    state.services.haptics.play(HapticCue.error);
    _fx.currentState?.wrong();
    setState(() {
      _answered = true;
      _feedback[q.answer.id] = TileFeedback.reveal;
    });
    _next(wrong: true);
  }

  void _tap(Jamo jamo) {
    if (_answered) return; // ignore taps during the feedback pause
    final state = AppScope.of(context);
    final q = _displayQ!;
    final pointsBefore = _round!.score.points;
    final correct = _round!
        .answer(jamo, secondsLeft: _secondsLeft, tracker: state.progress.errors);

    setState(() {
      _answered = true;
      if (correct) {
        _feedback[jamo.id] = TileFeedback.correct;
      } else {
        _feedback[jamo.id] = TileFeedback.wrong;
        _feedback[q.answer.id] = TileFeedback.reveal;
      }
    });

    if (correct) {
      state.services.audio.playSlot(_round!.score.combo >= 3
          ? AudioSlots.combo(_round!.score.multiplier + 1)
          : AudioSlots.tapCorrect);
      state.services.haptics.play(
          _round!.score.combo >= 3 ? HapticCue.success : HapticCue.light);
      _fx.currentState
          ?.correct(points: _round!.score.points - pointsBefore);
      _particles.forward(from: 0);
    } else {
      state.services.audio.playSlot(AudioSlots.tapWrong);
      state.services.haptics.play(HapticCue.error);
      _fx.currentState?.wrong();
    }
    _next(wrong: !correct);
  }

  void _next({required bool wrong}) {
    _ticker?.cancel();
    if (_round!.finished) {
      // Let the last answer's feedback land before the results screen.
      Future.delayed(Duration(milliseconds: wrong ? 900 : 500), () {
        if (!mounted) return;
        final touched =
            _round!.questions.map((q) => q.answer.id).toSet().toList();
        Navigator.of(context).pushReplacement(HqPageRoute(
            page: ResultScreen(
          stage: StageId.jamoHunt,
          level: widget.level,
          score: _round!.score,
          touchedJamoIds: touched,
        )));
      });
      return;
    }
    // Wrong answers pause longer so the revealed answer registers.
    Future.delayed(Duration(milliseconds: wrong ? 900 : 450), () {
      if (!mounted) return;
      setState(_startQuestion);
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _lead?.cancel();
    _particles.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final round = _round!;
    final q = _displayQ;
    if (q == null) return const Scaffold(body: SizedBox());

    return Scaffold(
      body: FeedbackFx(
        key: _fx,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.close, color: HqColors.inkSoft),
                        onPressed: () => Navigator.of(context).pop()),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _secondsLeft / JamoHuntRound.questionSeconds,
                          minHeight: 10,
                          backgroundColor:
                              HqColors.celadon.withValues(alpha: 0.4),
                          valueColor: AlwaysStoppedAnimation(_secondsLeft < 2
                              ? HqColors.dancheongRed
                              : HqColors.dancheongGreen),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _ComboBadge(score: round.score),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _playPrompt,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: HqColors.dancheongBlue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x332B2622), offset: Offset(2, 4))
                      ],
                    ),
                    child: const Icon(Icons.volume_up,
                        color: Colors.white, size: 48),
                  ),
                ),
                const SizedBox(height: 10),
                Text('이 소리의 자모를 찾으세요',
                    style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        for (final choice in q.choices)
                          _JamoTile(
                            jamo: choice,
                            feedback:
                                _feedback[choice.id] ?? TileFeedback.none,
                            onTap: () => _tap(choice),
                          ),
                      ],
                    ),
                    IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _particles,
                        builder: (_, __) => CustomPaint(
                          size: const Size(240, 140),
                          painter: _ParticlePainter(_particles.value),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComboBadge extends StatelessWidget {
  const _ComboBadge({required this.score});

  final RoundScore score;

  @override
  Widget build(BuildContext context) {
    final active = score.combo >= 3;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active ? HqColors.dancheongRed : HqColors.celadon,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        active ? 'x${score.multiplier} 콤보 ${score.combo}' : '콤보 ${score.combo}',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}

class _JamoTile extends StatelessWidget {
  const _JamoTile({
    required this.jamo,
    required this.onTap,
    this.feedback = TileFeedback.none,
  });

  final Jamo jamo;
  final VoidCallback onTap;
  final TileFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final badge = FeedbackTileStyle.badge(feedback);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: FeedbackTileStyle.scale(feedback),
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: FeedbackTileStyle.background(feedback),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: FeedbackTileStyle.border(feedback),
              width: feedback == TileFeedback.none ? 1 : 2.5,
            ),
            boxShadow: [
              if (feedback == TileFeedback.correct ||
                  feedback == TileFeedback.reveal)
                BoxShadow(
                    color:
                        HqColors.dancheongGreen.withValues(alpha: 0.45),
                    blurRadius: 18,
                    spreadRadius: 2)
              else
                const BoxShadow(
                    color: Color(0x1A2B2622), offset: Offset(2, 3)),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Text(jamo.char,
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: HqColors.ink)),
              ),
              if (badge.isNotEmpty)
                Positioned(
                  top: 4,
                  right: 8,
                  child: Text(badge,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: FeedbackTileStyle.badgeColor(feedback))),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter(this.t);

  final double t;
  static final _rng = Random(7);
  static final _seeds = List.generate(
      20, (_) => (_rng.nextDouble() * 2 - 1, _rng.nextDouble() * 2 - 1));

  @override
  void paint(Canvas canvas, Size size) {
    if (t == 0 || t == 1) return;
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    for (var i = 0; i < _seeds.length; i++) {
      final (dx, dy) = _seeds[i];
      paint.color = switch (i % 3) {
        0 => HqColors.obangYellow,
        1 => HqColors.dancheongRed,
        _ => HqColors.dancheongGreen,
      }
          .withValues(alpha: (1 - t));
      canvas.drawCircle(
          center + Offset(dx, dy) * 110 * Curves.easeOut.transform(t),
          5 * (1 - t) + 1,
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.t != t;
}
