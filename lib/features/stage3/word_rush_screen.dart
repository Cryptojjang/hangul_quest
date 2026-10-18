/// Stage 3 — Word Rush: read the word, tap the matching image. Speed bonus,
/// with explicit answer feedback: correct card pops green (+flash +score),
/// wrong pick shakes red and the right card is revealed.
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/data/curriculum.dart';
import '../../core/data/vocab.dart';
import '../../core/game/round_engine.dart';
import '../../core/hangul/hangul.dart';
import '../../platform/audio/audio_asset_manager.dart';
import '../../platform/device/device.dart';
import '../../platform/images/word_image_resolver.dart';
import '../../theme/feedback_fx.dart';
import '../../theme/hq_theme.dart';
import '../results/result_screen.dart';

class WordRushScreen extends StatefulWidget {
  const WordRushScreen({super.key, required this.level});

  final int level;

  @override
  State<WordRushScreen> createState() => _WordRushScreenState();
}

class _WordRushScreenState extends State<WordRushScreen> {
  WordRushRound? _round;
  Timer? _ticker;
  Timer? _lead;
  double _secondsLeft = WordRushRound.questionSeconds.toDouble();

  WordRushQuestion? _displayQ;
  final Map<String, TileFeedback> _feedback = {};
  bool _answered = false;
  final _fx = GlobalKey<FeedbackFxState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_round != null) return;
    _round = WordRushRound(level: stage3Levels[widget.level - 1]);
    _startQuestion(firstOfRound: true);
  }

  void _startQuestion({bool firstOfRound = false}) {
    _displayQ = _round!.current;
    _feedback.clear();
    _answered = false;
    _secondsLeft = WordRushRound.questionSeconds.toDouble();
    _ticker?.cancel();
    _lead?.cancel();
    // Prompt + answer timer start together after a lead-in (long on round
    // entry so the transition never swallows the first word).
    _lead = Timer(Duration(milliseconds: firstOfRound ? 550 : 150), () {
      if (!mounted) return;
      final q = _displayQ;
      if (q != null) AppScope.of(context).playWord(q.answer.id);
      _ticker?.cancel();
      _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
        setState(() => _secondsLeft -= 0.1);
        if (_secondsLeft <= 0) _pick(null);
      });
    });
  }

  void _pick(VocabWord? word) {
    if (_answered) return;
    final state = AppScope.of(context);
    final q = _displayQ!;
    final pointsBefore = _round!.score.points;
    final bool correct;
    if (word == null) {
      // timeout counts as wrong on the answer word
      _round!.answer(
          q.options.firstWhere((o) => o.id != q.answer.id),
          tracker: state.progress.errors);
      correct = false;
    } else {
      correct = _round!.answer(word,
          secondsLeft: _secondsLeft, tracker: state.progress.errors);
    }

    setState(() {
      _answered = true;
      if (correct) {
        _feedback[word!.id] = TileFeedback.correct;
      } else {
        if (word != null) _feedback[word.id] = TileFeedback.wrong;
        _feedback[q.answer.id] = TileFeedback.reveal;
      }
    });

    if (correct) {
      state.services.audio.playSlot(_round!.score.combo >= 3
          ? AudioSlots.combo(_round!.score.multiplier + 1)
          : AudioSlots.tapCorrect);
      state.services.haptics.play(HapticCue.light);
      _fx.currentState
          ?.correct(points: _round!.score.points - pointsBefore);
    } else {
      state.services.audio.playSlot(AudioSlots.tapWrong);
      state.services.haptics.play(HapticCue.error);
      _fx.currentState?.wrong();
    }

    _ticker?.cancel();
    final delay = correct ? 500 : 950;
    if (_round!.finished) {
      Future.delayed(Duration(milliseconds: delay), () {
        if (!mounted) return;
        final touched = <String>{
          for (final qq in _round!.questions)
            ...jamoIdsInWord(qq.answer.korean)
        }.toList();
        Navigator.of(context).pushReplacement(HqPageRoute(
            page: ResultScreen(
          stage: StageId.wordRush,
          level: widget.level,
          score: _round!.score,
          touchedJamoIds: touched,
        )));
      });
      return;
    }
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) setState(_startQuestion);
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _lead?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          value: _secondsLeft / WordRushRound.questionSeconds,
                          minHeight: 10,
                          backgroundColor:
                              HqColors.celadon.withValues(alpha: 0.4),
                          valueColor: AlwaysStoppedAnimation(_secondsLeft < 2
                              ? HqColors.dancheongRed
                              : HqColors.dancheongGreen),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const Spacer(),
                Text(q.answer.korean,
                    style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w800,
                        color: HqColors.ink)),
                Text('읽고, 맞는 그림을 고르세요',
                    style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    for (final option in q.options)
                      _WordCard(
                        word: option,
                        feedback: _feedback[option.id] ?? TileFeedback.none,
                        onTap: () => _pick(option),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WordCard extends StatelessWidget {
  const _WordCard({
    required this.word,
    required this.onTap,
    this.feedback = TileFeedback.none,
  });

  final VocabWord word;
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
          padding: const EdgeInsets.all(12),
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
                    color: HqColors.dancheongGreen.withValues(alpha: 0.45),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _WordArt(word: word),
                    const SizedBox(height: 4),
                    Text(word.english,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (badge.isNotEmpty)
                Positioned(
                  top: 0,
                  right: 4,
                  child: Text(badge,
                      style: TextStyle(
                          fontSize: 18,
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

/// Illustration slot: bundled art when the pipeline has delivered it,
/// per-word emoji otherwise (WordImageResolver).
class _WordArt extends StatelessWidget {
  const _WordArt({required this.word});

  final VocabWord word;

  @override
  Widget build(BuildContext context) {
    final asset = WordImageResolver.instance.resolve(word);
    if (asset != null) {
      return Image.asset(asset, width: 56, height: 56, fit: BoxFit.contain);
    }
    return Text(WordImageResolver.emojiFor(word),
        style: const TextStyle(fontSize: 40));
  }
}
