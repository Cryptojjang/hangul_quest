/// Smart Review — SRS-personalized 5-minute session (premium; 1 free
/// teaser/day). Quiz format: hear the item, tap the right jamo/syllable.
library;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/hangul/hangul.dart';
import '../../core/srs/srs.dart';
import '../../platform/audio/audio_asset_manager.dart';
import '../../platform/device/device.dart';
import '../../theme/feedback_fx.dart';
import '../../theme/hq_theme.dart';
import '../home/home_screen.dart';
import '../paywall/paywall_screen.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<String>? _session;
  int _cursor = 0;
  int _correct = 0;
  List<Jamo>? _choices;
  final _rng = Random();
  final Map<String, TileFeedback> _feedback = {};
  bool _answered = false;
  final _fx = GlobalKey<FeedbackFxState>();
  Timer? _lead;
  bool _firstPrompt = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_session != null) return;
    // NOTE: the teaser is consumed by the caller (AppState.startReviewSession)
    // BEFORE navigating here — never mutate app state during build.
    final state = AppScope.of(context);
    final fallback = [
      ...state.progress.errors.weakestItems(limit: 10),
      ...state.progress.codex.keys,
    ];
    _session = state.progress.srs
        .buildSession(size: 12, fallbackPool: fallback)
        .where((id) => jamoById.containsKey(id))
        .toList();
    if (_session!.isEmpty) {
      // Brand-new player: seed with basic consonants.
      _session = choseongTable.take(6).map((j) => j.id).toList();
    }
    _buildChoices();
  }

  void _buildChoices() {
    final answer = jamoById[_session![_cursor]]!;
    final pool = switch (answer.role) {
      JamoRole.choseong => choseongTable,
      JamoRole.jungseong => jungseongTable,
      JamoRole.jongseong => jongseongTable,
    };
    final distractors = pool.where((j) => j.id != answer.id).toList()
      ..shuffle(_rng);
    _choices = [answer, ...distractors.take(3)]..shuffle(_rng);
    // First prompt waits out the page transition; later ones a short breath.
    final lead = _firstPrompt ? 550 : 150;
    _firstPrompt = false;
    _lead?.cancel();
    _lead = Timer(Duration(milliseconds: lead), () {
      if (mounted) AppScope.of(context).playJamo(answer);
    });
  }

  @override
  void dispose() {
    _lead?.cancel();
    super.dispose();
  }

  void _tap(Jamo picked) {
    if (_answered) return;
    final state = AppScope.of(context);
    final answerId = _session![_cursor];
    final ok = picked.id == answerId;
    state.progress.srs
        .review(answerId, ok ? ReviewGrade.good : ReviewGrade.again);
    setState(() {
      _answered = true;
      _feedback[picked.id] = ok ? TileFeedback.correct : TileFeedback.wrong;
      if (!ok) _feedback[answerId] = TileFeedback.reveal;
    });
    if (ok) {
      _correct++;
      state.progress.errors.recordCorrect(answerId);
      state.services.audio.playSlot(AudioSlots.tapCorrect);
      state.services.haptics.play(HapticCue.light);
      _fx.currentState?.correct();
    } else {
      state.progress.errors.recordWrong(answerId);
      state.services.audio.playSlot(AudioSlots.tapWrong);
      state.services.haptics.play(HapticCue.error);
      _fx.currentState?.wrong();
    }
    state.store.save();

    Future.delayed(Duration(milliseconds: ok ? 450 : 900), () {
      if (!mounted) return;
      if (_cursor + 1 >= _session!.length) {
        _finish();
        return;
      }
      setState(() {
        _cursor++;
        _answered = false;
        _feedback.clear();
        _buildChoices();
      });
    });
  }

  void _finish() {
    final state = AppScope.of(context);
    final isPremium = state.isPremium;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: HqColors.hanji,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('복습 완료!',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('$_correct / ${_session!.length} 정답',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: HqColors.dancheongGreen)),
              const SizedBox(height: 16),
              if (!isPremium) ...[
                Text('오늘의 무료 복습을 다 썼어요.\n프리미엄은 필요한 만큼 무제한으로 복습해요.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),
                HqButton(
                  label: '무제한 복습 열기',
                  expanded: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Teaser end = conversion trigger (spec §5.3-③).
                    PaywallScreen.show(context,
                        trigger: 'review_teaser_end');
                  },
                ),
                const SizedBox(height: 8),
              ],
              HqButton(
                label: '맵으로',
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

  @override
  Widget build(BuildContext context) {
    final answer = jamoById[_session![_cursor]]!;
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
                    child: Text('스마트 복습  ${_cursor + 1}/${_session!.length}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => AppScope.of(context).playJamo(answer),
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                      color: HqColors.dancheongBlue, shape: BoxShape.circle),
                  child: const Icon(Icons.volume_up,
                      color: Colors.white, size: 44),
                ),
              ),
              const SizedBox(height: 12),
              Text('어떤 자모의 소리일까요?',
                  style: Theme.of(context).textTheme.bodySmall),
              const Spacer(),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  for (final c in _choices!)
                    GestureDetector(
                      onTap: () => _tap(c),
                      child: AnimatedScale(
                        scale: FeedbackTileStyle.scale(
                            _feedback[c.id] ?? TileFeedback.none),
                        duration: const Duration(milliseconds: 160),
                        curve: Curves.easeOutBack,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 140),
                          width: 84,
                          height: 84,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: FeedbackTileStyle.background(
                                _feedback[c.id] ?? TileFeedback.none),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: FeedbackTileStyle.border(
                                  _feedback[c.id] ?? TileFeedback.none),
                              width: (_feedback[c.id] ?? TileFeedback.none) ==
                                      TileFeedback.none
                                  ? 1
                                  : 2.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0x1A2B2622),
                                  offset: Offset(2, 3))
                            ],
                          ),
                          child: Text(c.char,
                              style: const TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
