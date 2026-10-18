/// Principle mini-lesson: ≤60s, interactive, always skippable (spec §4.3).
/// Exactly fills Duolingo's "no system explanation" gap — nothing more.
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/data/curriculum.dart';
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

  static const _lessons = {
    StageId.jamoHunt: (
      '소리를 그린 문자',
      'ㄱ은 혀뿌리가 목을 막는 모양, ㅁ은 입술 모양이에요.\n한글 자음은 발음 기관을 그린 그림이에요.\n\n지금부터 들리는 소리의 "모양"을 찾아보세요.',
      'ㄱ ㄴ ㅁ ㅅ ㅇ',
    ),
    StageId.blockBuilder: (
      '한글은 왜 블록처럼 조립될까?',
      '한글은 알파벳처럼 옆으로 늘어놓지 않고,\n첫소리(초성) + 가운뎃소리(중성) + 받침(종성)을\n한 칸에 쌓아요.\n\nㄱ + ㅏ = 가.  ㄱ + ㅏ + ㅇ = 강.\n모음 모양에 따라 블록이 놓이는 자리가 달라져요.',
      '가 → 강',
    ),
    StageId.wordRush: (
      '이제 진짜 단어를 읽어요',
      '조립할 수 있으면 읽을 수 있어요.\n김치 = 김 + 치. 이미 아는 글자들이에요.\n\n최대한 빨리 읽고 맞는 그림을 고르세요.',
      '김치 · 사랑 · 안녕',
    ),
    StageId.pronunciation: (
      '이제 소리 내어 볼까요?',
      '듣고 → 조립하고 → 읽었다면, 마지막은 말하기예요.\n마이크에 대고 발음하면 기기 안에서만 분석해\n어떤 소리가 좋았는지 알려드려요.',
      '안녕',
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
    final (title, body, sample) = _lessons[widget.stage]!;
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
              Text(sample,
                  style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                      color: HqColors.dancheongBlue)),
              const SizedBox(height: 20),
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
