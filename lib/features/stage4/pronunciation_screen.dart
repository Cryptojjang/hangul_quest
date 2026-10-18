/// Stage 4 — Pronunciation Challenge (premium): on-device speech recognition
/// scores the player's jamo/word pronunciation with visual feedback.
library;

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/data/curriculum.dart';
import '../../core/data/vocab.dart';
import '../../core/game/round_engine.dart';
import '../../core/hangul/hangul.dart';
import '../../platform/device/device.dart';
import '../../theme/hq_theme.dart';
import '../results/result_screen.dart';

class PronunciationScreen extends StatefulWidget {
  const PronunciationScreen({super.key, required this.level});

  final int level;

  @override
  State<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> {
  late final List<({String text, String? wordId, Jamo? jamo})> _items;
  final RoundScore _score = RoundScore();
  final Set<String> _touched = {};
  int _cursor = 0;
  bool _listening = false;
  bool _permissionDenied = false;
  int? _lastScore;
  Map<String, bool> _feedback = const {};

  @override
  void initState() {
    super.initState();
    final level = stage4Levels[widget.level - 1];
    _items = [
      for (final id in level.jamoIds)
        (
          text: id.startsWith('v_')
              ? _vowelSyllable(id)
              : _consonantSyllable(id),
          wordId: null,
          jamo: jamoById[id],
        ),
      for (final id in level.wordIds)
        (text: vocabById[id]!.korean, wordId: id, jamo: null),
    ];
  }

  /// Jamo are pronounced as syllables for recognition (ㄱ → 가, ㅏ → 아).
  static String _consonantSyllable(String jamoId) {
    final j = jamoById[jamoId]!;
    return compose(j.index, 0).char; // consonant + ㅏ
  }

  static String _vowelSyllable(String jamoId) {
    final j = jamoById[jamoId]!;
    return compose(11, j.index).char; // ㅇ + vowel
  }

  Future<void> _record() async {
    final state = AppScope.of(context);
    final speech = state.services.speech;

    if (!await speech.requestPermission()) {
      setState(() => _permissionDenied = true);
      return;
    }

    setState(() {
      _listening = true;
      _lastScore = null;
    });
    await state.services.audio.setRecordingMode(true);
    final result = await speech.listen();
    await state.services.audio.setRecordingMode(false);
    if (!mounted) return;

    final target = _items[_cursor].text;
    if (result == null) {
      setState(() => _listening = false);
      return;
    }
    final scored = state.services.scorer.score(target, result);
    final pass = scored.score >= 60;
    if (pass) {
      _score.addCorrect(base: scored.score ~/ 5);
    } else {
      _score.addWrong();
    }
    for (final id in jamoIdsInWord(target)) {
      _touched.add(id);
      if (pass) {
        state.progress.errors.recordCorrect(id);
      } else {
        state.progress.errors.recordWrong(id);
      }
    }
    state.services.haptics
        .play(pass ? HapticCue.success : HapticCue.error);
    setState(() {
      _listening = false;
      _lastScore = scored.score;
      _feedback = scored.perJamoFeedback;
    });
  }

  void _next() {
    if (_cursor + 1 >= _items.length) {
      Navigator.of(context).pushReplacement(HqPageRoute(
          page: ResultScreen(
        stage: StageId.pronunciation,
        level: widget.level,
        score: _score,
        touchedJamoIds: _touched.toList(),
      )));
      return;
    }
    setState(() {
      _cursor++;
      _lastScore = null;
      _feedback = const {};
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final item = _items[_cursor];

    if (_permissionDenied) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mic_off, size: 64, color: HqColors.inkSoft),
                const SizedBox(height: 16),
                Text('마이크 권한이 필요해요',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  '발음 채점은 기기 안에서만 처리되고\n음성은 저장·전송되지 않아요.\n설정에서 마이크를 허용해 주세요.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                HqButton(
                    label: '맵으로 돌아가기',
                    onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
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
                    child: Text('${_cursor + 1} / ${_items.length}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  IconButton(
                      icon: const Icon(Icons.volume_up,
                          color: HqColors.dancheongBlue),
                      onPressed: () {
                        if (item.wordId != null) {
                          state.playWord(item.wordId!);
                        } else if (item.jamo != null) {
                          state.playJamo(item.jamo!);
                        }
                      }),
                ],
              ),
              const Spacer(),
              Text(item.text,
                  style: const TextStyle(
                      fontSize: 88,
                      fontWeight: FontWeight.w800,
                      color: HqColors.ink)),
              const SizedBox(height: 8),
              Text('듣고, 따라 말해보세요',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 24),
              if (_lastScore != null) _ScoreRing(score: _lastScore!, feedback: _feedback),
              const Spacer(),
              GestureDetector(
                onTap: _listening ? null : _record,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: _listening
                        ? HqColors.dancheongRed
                        : HqColors.dancheongBlue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (_listening)
                        BoxShadow(
                            color:
                                HqColors.dancheongRed.withValues(alpha: 0.4),
                            blurRadius: 24,
                            spreadRadius: 8),
                    ],
                  ),
                  child: Icon(_listening ? Icons.graphic_eq : Icons.mic,
                      color: Colors.white, size: 44),
                ),
              ),
              const SizedBox(height: 16),
              if (_lastScore != null)
                HqButton(
                    label: _lastScore! >= 60 ? '다음' : '한 번 더 / 다음',
                    expanded: true,
                    onPressed: _next),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.score, required this.feedback});

  final int score;
  final Map<String, bool> feedback;

  @override
  Widget build(BuildContext context) {
    final color = score >= 80
        ? HqColors.dancheongGreen
        : (score >= 60 ? HqColors.obangYellow : HqColors.dancheongRed);
    return Column(
      children: [
        SizedBox(
          width: 110,
          height: 110,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 10,
                  backgroundColor: HqColors.celadon.withValues(alpha: 0.4),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Text('$score',
                  style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w800, color: color)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          children: [
            for (final e in feedback.entries)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: e.value
                      ? HqColors.dancheongGreen.withValues(alpha: 0.15)
                      : HqColors.dancheongRed.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${jamoById[e.key]?.char ?? e.key} ${e.value ? '좋아요' : '아쉬워요'}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: e.value
                          ? HqColors.dancheongGreen
                          : HqColors.dancheongRed),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
