/// Principle mini-lesson: ≤60s, interactive, always skippable (spec §4.3).
/// Exactly fills Duolingo's "no system explanation" gap — nothing more.
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/data/curriculum.dart';
import '../../core/hangul/hangul.dart';
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
  static const _lessons = {
    StageId.jamoHunt: (
      '소리를 그린 문자',
      'ㄱ은 혀뿌리가 목을 막는 모양, ㅁ은 입술 모양이에요.\n한글 자음은 발음 기관을 그린 그림이에요.',
      ['ㄱ', 'ㄴ', 'ㅁ', 'ㅅ', 'ㅇ'],
      '탭해서 소리를 들어 보세요',
    ),
    StageId.blockBuilder: (
      '한글은 왜 블록처럼 조립될까?',
      '첫소리 + 가운뎃소리 + 받침을 옆으로 늘어놓지 않고\n한 칸에 쌓아요. 모음 모양에 따라 자리가 달라져요.',
      ['ㄱ', 'ㄱ + ㅏ', '가', '가 + ㅇ', '강'],
      '탭해서 글자를 조립해 보세요',
    ),
    StageId.wordRush: (
      '이제 진짜 단어를 읽어요',
      '조립할 수 있으면 읽을 수 있어요.\n최대한 빨리 읽고 맞는 그림을 고르세요.',
      ['김', '김 + 치', '김치'],
      '탭해서 단어를 만들어 보세요',
    ),
    StageId.pronunciation: (
      '이제 소리 내어 볼까요?',
      '마지막은 말하기예요. 마이크에 대고 발음하면\n기기 안에서만 분석해 어떤 소리가 좋았는지 알려드려요.',
      ['안', '녕', '안녕'],
      '탭해서 먼저 들어 보세요',
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
    final (title, body, frames, prompt) = _lessons[widget.stage]!;
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
                  child: const Text('건너뛰기 →',
                      style: TextStyle(color: HqColors.inkSoft)),
                ),
              ),
              const Spacer(),
              _TapDemo(frames: frames, prompt: prompt),
              const SizedBox(height: 24),
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              HqButton(label: '플레이', expanded: true, onPressed: _start),
              const SizedBox(height: 8),
              Center(
                child: Text('${_maxSeconds - _elapsed}초 후 자동 시작',
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
                    ? '다시 보려면 탭'
                    : '${widget.prompt}  ${_i + 1}/${widget.frames.length}',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
