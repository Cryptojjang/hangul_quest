/// Shared answer-feedback effects (design spec §3): full-screen color flash,
/// screen shake on mistakes, floating score text on correct answers.
///
/// Wrap a game screen's body in [FeedbackFx] and trigger via a
/// GlobalKey<FeedbackFxState>:
///
///   _fx.currentState?.correct(points: 24);
///   _fx.currentState?.wrong();
library;

import 'dart:math';

import 'package:flutter/material.dart';

import 'hq_theme.dart';

class FeedbackFx extends StatefulWidget {
  const FeedbackFx({super.key, required this.child});

  final Widget child;

  @override
  State<FeedbackFx> createState() => FeedbackFxState();
}

class FeedbackFxState extends State<FeedbackFx>
    with TickerProviderStateMixin {
  late final AnimationController _flash = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 380));
  late final AnimationController _shake = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 450));
  late final AnimationController _score = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900));

  Color _flashColor = HqColors.dancheongGreen;
  String _scoreText = '';

  /// Green flash + optional floating "+points".
  void correct({int? points}) {
    _flashColor = HqColors.dancheongGreen;
    _flash.forward(from: 0);
    if (points != null && points > 0) {
      _scoreText = '+$points';
      _score.forward(from: 0);
    }
  }

  /// Red flash + horizontal screen shake.
  void wrong() {
    _flashColor = HqColors.dancheongRed;
    _flash.forward(from: 0);
    _shake.forward(from: 0);
  }

  @override
  void dispose() {
    _flash.dispose();
    _shake.dispose();
    _score.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_flash, _shake, _score]),
      builder: (context, child) {
        final st = _shake.value;
        // Damped oscillation: strong at first, settles to zero.
        final dx = st == 0 || st == 1
            ? 0.0
            : sin(st * pi * 5) * 14 * (1 - st);

        final ft = _flash.value;
        final flashAlpha = ft == 0 || ft == 1 ? 0.0 : (1 - ft) * 0.22;

        final sc = _score.value;

        return Stack(
          fit: StackFit.passthrough,
          children: [
            Transform.translate(offset: Offset(dx, 0), child: child),
            if (flashAlpha > 0)
              Positioned.fill(
                child: IgnorePointer(
                  child: ColoredBox(
                      color: _flashColor.withValues(alpha: flashAlpha)),
                ),
              ),
            if (sc > 0 && sc < 1)
              Positioned(
                left: 0,
                right: 0,
                top: 120 - 70 * Curves.easeOut.transform(sc),
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 1 - Curves.easeIn.transform(sc),
                    child: Text(
                      _scoreText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: HqColors.dancheongGreen,
                        shadows: [
                          Shadow(
                              color: Colors.white.withValues(alpha: 0.8),
                              blurRadius: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      child: widget.child,
    );
  }
}

/// Answer-state styling for a choice tile/card, shared by stage 1/3 and
/// review: neutral → picked-correct (green pop) / picked-wrong (red shake) /
/// revealed answer (green pulse so learners always SEE the right one).
enum TileFeedback { none, correct, wrong, reveal }

class FeedbackTileStyle {
  static Color background(TileFeedback f) => switch (f) {
        TileFeedback.correct => const Color(0xFFDCEDDE),
        TileFeedback.wrong => const Color(0xFFF3D8D5),
        TileFeedback.reveal => const Color(0xFFEAF4EC),
        TileFeedback.none => Colors.white,
      };

  static Color border(TileFeedback f) => switch (f) {
        TileFeedback.correct => HqColors.dancheongGreen,
        TileFeedback.wrong => HqColors.dancheongRed,
        TileFeedback.reveal => HqColors.dancheongGreen,
        TileFeedback.none => HqColors.ink.withValues(alpha: 0.08),
      };

  static double scale(TileFeedback f) => switch (f) {
        TileFeedback.correct => 1.12,
        TileFeedback.wrong => 0.96,
        _ => 1.0,
      };

  /// Badge glyph overlaid on the tile corner ('' = none).
  static String badge(TileFeedback f) => switch (f) {
        TileFeedback.correct => '○',
        TileFeedback.reveal => '○',
        TileFeedback.wrong => '✕',
        TileFeedback.none => '',
      };

  static Color badgeColor(TileFeedback f) =>
      f == TileFeedback.wrong ? HqColors.dancheongRed : HqColors.dancheongGreen;
}
