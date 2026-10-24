/// Principle mini-lesson: ≤60s, interactive, always skippable (spec §4.3).
/// Exactly fills Duolingo's "no system explanation" gap — nothing more.
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/data/curriculum.dart';
import '../../core/hangul/hangul.dart';
import '../../l10n/l10n.dart';
import '../../theme/hq_theme.dart';
import '../stage1/jamo_hunt_screen.dart';
import '../stage2/block_builder_screen.dart';
import '../stage3/word_rush_screen.dart';
import '../stage4/pronunciation_screen.dart';

class MiniLessonScreen extends StatefulWidget {
  const MiniLessonScreen({super.key, required this.stage, required this.level});

  final StageId stage;
  final int level;

  @override
  State<MiniLessonScreen> createState() => _MiniLessonScreenState();
}

class _MiniLessonScreenState extends State<MiniLessonScreen> {
  static const _maxSeconds = 60;
  Timer? _timer;
  int _elapsed = 0;

  /// (title, body, demo frames, demo prompt). Frames are stepped through by
  /// tapping; single jamo/syllable frames play their sound.
  static (String, String, List<String>, String) _lesson(
          StageId stage, L10n l) =>
      switch (stage) {
        StageId.jamoHunt => (
            l.miniJamoTitle,
            l.miniJamoBody,
            const ['ㄱ', 'ㄴ', 'ㅁ', 'ㅅ', 'ㅇ'],
            l.miniJamoPrompt,
          ),
        StageId.blockBuilder => (
            l.miniBuilderTitle,
            l.miniBuilderBody,
            const ['ㄱ', 'ㄱ + ㅏ', '가', '가 + ㅇ', '강'],
            l.miniBuilderPrompt,
          ),
        StageId.wordRush => (
            l.miniWordTitle,
            l.miniWordBody,
            const ['김', '김 + 치', '김치'],
            l.miniWordPrompt,
          ),
        StageId.pronunciation => (
            l.miniSpeakTitle,
            l.miniSpeakBody,
            const ['안', '녕', '안녕'],
            l.miniSpeakPrompt,
          ),
      };

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed++);
      if (_elapsed >= _maxSeconds) _start();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    final page = switch (widget.stage) {
      StageId.jamoHunt => JamoHuntScreen(level: widget.level),
      StageId.blockBuilder => BlockBuilderScreen(level: widget.level),
      StageId.wordRush => WordRushScreen(level: widget.level),
      StageId.pronunciation => PronunciationScreen(level: widget.level),
    };
    Navigator.of(context).pushReplacement(HqPageRoute(page: page));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final (title, body, frames, prompt) = _lesson(widget.stage, l);
    AppScope.of(context).onStageStart(widget.stage, widget.level);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _start,
                  child: Text(l.miniSkip,
                      style: const TextStyle(color: HqColors.inkSoft)),
                ),
              ),
              const Spacer(),
              _TapDemo(frames: frames, prompt: prompt),
              const SizedBox(height: 24),
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              HqButton(label: l.commonPlay, expanded: true, onPressed: _start),
              const SizedBox(height: 8),
              Center(
                child: Text(l.miniStartsIn(_maxSeconds - _elapsed),
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tap-to-step demo: each tap reveals the next frame (ㄱ → ㄱ + ㅏ → 가) with
/// a scale-in, and plays the frame's sound when it is a single jamo or
/// syllable. Loops back to the start after the last frame.
class _TapDemo extends StatefulWidget {
  const _TapDemo({required this.frames, required this.prompt});

  final List<String> frames;
  final String prompt;

  @override
  State<_TapDemo> createState() => _TapDemoState();
}

class _TapDemoState extends State<_TapDemo> {
  int _i = 0;

  void _play(String frame) {
    final state = AppScope.of(context);
    final jamo = [...choseongTable, ...jungseongTable]
        .where((j) => j.char == frame)
        .firstOrNull;
    if (jamo != null) {
      state.playJamo(jamo);
    } else if (frame.runes.length == 1 && isSyllable(frame.runes.first)) {
      state.playSyllable(decompose(frame.runes.first));
    }
  }

  void _next() {
    setState(() => _i = (_i + 1) % widget.frames.length);
    _play(widget.frames[_i]);
  }

  @override
  Widget build(BuildContext context) {
    final frame = widget.frames[_i];
    final last = _i == widget.frames.length - 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HqCard(
          onTap: _next,
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: Tween(begin: 0.85, end: 1.0).animate(
                    CurvedAnimation(parent: anim, curve: Curves.easeOutBack)),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: Text(
                frame,
                key: ValueKey(_i),
                style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    color: last
                        ? HqColors.dancheongGreen
                        : HqColors.dancheongBlue),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.touch_app_rounded,
                size: 16, color: HqColors.inkSoft),
            const SizedBox(width: 4),
            Text(
                last
                    ? context.l.miniTapToReplay
                    : '${widget.prompt}  ${_i + 1}/${widget.frames.length}',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
