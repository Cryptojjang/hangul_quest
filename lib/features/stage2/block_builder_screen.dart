/// Stage 2 — Block Builder: THE core differentiator.
///
/// Drag choseong/jungseong/jongseong blocks into assembly slots. The slot
/// layout morphs with the vowel type (vertical / horizontal / mixed), and the
/// completed syllable "comes alive": scale bounce + gold glow + native
/// pronunciation + success haptic.
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/data/content_keys.dart';
import '../../core/data/curriculum.dart';
import '../../core/game/round_engine.dart';
import '../../core/hangul/hangul.dart';
import '../../l10n/l10n.dart';
import '../../platform/audio/audio_asset_manager.dart';
import '../../platform/device/device.dart';
import '../../theme/feedback_fx.dart';
import '../../theme/hq_theme.dart';
import '../results/result_screen.dart';

class BlockBuilderScreen extends StatefulWidget {
  const BlockBuilderScreen({super.key, required this.level});

  final int level;

  @override
  State<BlockBuilderScreen> createState() => _BlockBuilderScreenState();
}

class _BlockBuilderScreenState extends State<BlockBuilderScreen>
    with SingleTickerProviderStateMixin {
  BlockBuilderRound? _round;
  String? _hint;
  final Set<String> _touchedJamo = {};
  final _fx = GlobalKey<FeedbackFxState>();
  Timer? _lead;

  late final AnimationController _celebrate = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_round != null) return;
    final state = AppScope.of(context);
    _round = BlockBuilderRound(
      level: stage2Levels[widget.level - 1],
      tracker: state.progress.errors,
    );
    // First target speaks after the page transition lands, never during it.
    _lead = Timer(const Duration(milliseconds: 550), () {
      if (mounted) _playTarget();
    });
  }

  void _playTarget() {
    final p = _round!.current;
    if (p != null) AppScope.of(context).playSyllable(p.target);
  }

  /// Tap-to-place: a tapped block goes to the slot for its role, through the
  /// same placement rules (and teaching hints) as a drop.
  static SlotKind _slotFor(Jamo block) => switch (block.role) {
        JamoRole.choseong => SlotKind.choseong,
        JamoRole.jungseong => SlotKind.jungseong,
        JamoRole.jongseong => SlotKind.jongseong,
      };

  Future<void> _onDrop(Jamo block, SlotKind slot) async {
    final state = AppScope.of(context);
    final puzzle = _round!.current!;
    final result = puzzle.place(block, slot);
    _touchedJamo.add(block.id);

    switch (result) {
      case PlacementResult.rejectedRole:
      case PlacementResult.rejectedWrong:
        state.services.audio.playSlot(AudioSlots.blockReject);
        state.services.haptics.play(HapticCue.error);
        _fx.currentState?.wrong();
        setState(() => _hint = puzzle.hintFor(block, slot));
      case PlacementResult.accepted:
        state.services.audio.playSlot(AudioSlots.blockDrop);
        state.services.haptics.play(HapticCue.medium);
        setState(() => _hint = null);
      case PlacementResult.completed:
        setState(() => _hint = null);
        state.services.audio.playSlot(AudioSlots.syllableComplete);
        state.services.haptics.play(HapticCue.success);
        await _celebrate.forward(from: 0);
        // The moment that sells the app: the assembled syllable speaks.
        await state.playSyllable(puzzle.assembled!);
        final pointsBefore = _round!.score.points;
        _round!.completeCurrent();
        _fx.currentState?.correct(points: _round!.score.points - pointsBefore);
        if (_round!.finished) {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(HqPageRoute(
              page: ResultScreen(
            stage: StageId.blockBuilder,
            level: widget.level,
            score: _round!.score,
            touchedJamoIds: _touchedJamo.toList(),
          )));
          return;
        }
        setState(() {});
        _playTarget();
    }
  }

  @override
  void dispose() {
    _lead?.cancel();
    _celebrate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final round = _round!;
    final puzzle = round.current;
    if (puzzle == null) return const Scaffold(body: SizedBox());
    final done = round.completedCount;

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
                      child: Text(
                          '${ct(context.localeCode, levelKey(StageId.blockBuilder, round.level.level), round.level.title)}'
                          '  ·  $done/${round.level.syllableTargets.length}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    IconButton(
                        icon: const Icon(Icons.volume_up,
                            color: HqColors.dancheongBlue),
                        onPressed: _playTarget),
                  ],
                ),
                const SizedBox(height: 4),
                Text(context.l.builderPrompt,
                    style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                _AssemblyBoard(
                    puzzle: puzzle, celebrate: _celebrate, onDrop: _onDrop),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: _hint == null
                      ? null
                      : Text(_hint!,
                          style: const TextStyle(
                              color: HqColors.dancheongRed,
                              fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
                _BlockTray(
                    puzzle: puzzle, onTap: (b) => _onDrop(b, _slotFor(b))),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The assembly board: slots positioned per the vowel layout, morphing
/// between layouts with an animated switcher.
class _AssemblyBoard extends StatelessWidget {
  const _AssemblyBoard(
      {required this.puzzle, required this.celebrate, required this.onDrop});

  final AssemblyPuzzle puzzle;
  final AnimationController celebrate;
  final Future<void> Function(Jamo, SlotKind) onDrop;

  @override
  Widget build(BuildContext context) {
    final layout = puzzle.layout;

    Widget slot(SlotKind kind, Jamo? placed, String label, Color color) =>
        _Slot(
            kind: kind,
            placed: placed,
            label: label,
            color: color,
            onDrop: onDrop);

    final cho = slot(SlotKind.choseong, puzzle.placedChoseong,
        context.l.slotInitial, HqColors.choseongBlock);
    final jung = slot(SlotKind.jungseong, puzzle.placedJungseong,
        context.l.slotVowel, HqColors.jungseongBlock);
    final jong = puzzle.needsJongseong
        ? slot(SlotKind.jongseong, puzzle.placedJongseong, context.l.slotFinal,
            HqColors.jongseongBlock)
        : null;

    final Widget core = switch (layout) {
      SyllableLayout.vertical => Row(
          mainAxisSize: MainAxisSize.min,
          children: [cho, const SizedBox(width: 8), jung]),
      SyllableLayout.horizontal => Column(
          mainAxisSize: MainAxisSize.min,
          children: [cho, const SizedBox(height: 8), jung]),
      SyllableLayout.mixed => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              cho,
              const SizedBox(width: 8),
              const SizedBox(width: 44),
            ]),
            const SizedBox(height: 8),
            jung,
          ],
        ),
    };

    return AnimatedBuilder(
      animation: celebrate,
      builder: (context, child) {
        final t = celebrate.value;
        final scale = t == 0
            ? 1.0
            : 1.0 + 0.25 * Curves.elasticOut.transform(t) * (1 - t * 0.6);
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: HqColors.ink.withValues(alpha: 0.08)),
            boxShadow: [
              const BoxShadow(color: Color(0x1A2B2622), offset: Offset(2, 4)),
              if (t > 0)
                BoxShadow(
                    color:
                        HqColors.obangYellow.withValues(alpha: 0.55 * (1 - t)),
                    blurRadius: 40 * t,
                    spreadRadius: 8 * t),
            ],
          ),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AnimatedSwitcher morphs the slot arrangement when the vowel type
          // changes between puzzles — the "combination rule made visible".
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOutBack,
            child: KeyedSubtree(
                key: ValueKey('${layout.name}-${puzzle.target.codePoint}'),
                child: core),
          ),
          if (jong != null) ...[const SizedBox(height: 8), jong],
          const SizedBox(height: 16),
          Text(
            puzzle.completed ? puzzle.assembled!.char : '?',
            style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w800,
                color: puzzle.completed
                    ? HqColors.dancheongGreen
                    : HqColors.celadon),
          ),
        ],
      ),
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({
    required this.kind,
    required this.placed,
    required this.label,
    required this.color,
    required this.onDrop,
  });

  final SlotKind kind;
  final Jamo? placed;
  final String label;
  final Color color;
  final Future<void> Function(Jamo, SlotKind) onDrop;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Jamo>(
      onAcceptWithDetails: (d) => onDrop(d.data, kind),
      builder: (context, candidates, rejected) {
        final hovering = candidates.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: placed != null
                ? color
                : color.withValues(alpha: hovering ? 0.5 : 0.18),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hovering ? HqColors.ink : color,
              width: hovering ? 2.5 : 1.5,
            ),
          ),
          child: placed != null
              ? Text(placed!.char,
                  style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: HqColors.ink))
              : Text(label,
                  style:
                      const TextStyle(fontSize: 11, color: HqColors.inkSoft)),
        );
      },
    );
  }
}

class _BlockTray extends StatelessWidget {
  const _BlockTray({required this.puzzle, required this.onTap});

  final AssemblyPuzzle puzzle;
  final void Function(Jamo) onTap;

  bool _isPlaced(Jamo j) =>
      identical(puzzle.placedChoseong, j) ||
      identical(puzzle.placedJungseong, j) ||
      identical(puzzle.placedJongseong, j);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        for (final block in puzzle.tray)
          if (_isPlaced(block))
            const SizedBox(width: 64, height: 64)
          else
            _DraggableBlock(block: block, onTap: () => onTap(block)),
      ],
    );
  }
}

class _DraggableBlock extends StatelessWidget {
  const _DraggableBlock({required this.block, required this.onTap});

  final Jamo block;
  final VoidCallback onTap;

  Color get _color => switch (block.role) {
        JamoRole.choseong => HqColors.choseongBlock,
        JamoRole.jungseong => HqColors.jungseongBlock,
        JamoRole.jongseong => HqColors.jongseongBlock,
      };

  Widget _tile({double scale = 1, double alpha = 1}) => Container(
        width: 64 * scale,
        height: 64 * scale,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _color.withValues(alpha: alpha),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: const Color(0x332B2622),
                offset: const Offset(2, 3) * scale)
          ],
        ),
        child: Text(block.char,
            style: TextStyle(
                fontSize: 32 * scale,
                fontWeight: FontWeight.w800,
                color: HqColors.ink)),
      );

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Draggable<Jamo>(
      data: block,
      onDragStarted: () {
        state.services.audio.playSlot(AudioSlots.blockPick);
        state.services.haptics.play(HapticCue.light);
      },
      feedback: Material(color: Colors.transparent, child: _tile(scale: 1.08)),
      childWhenDragging: _tile(alpha: 0.25),
      // A tap (no drag movement) places the block; dragging still works.
      child: GestureDetector(
        onTap: () {
          state.services.audio.playSlot(AudioSlots.blockPick);
          onTap();
        },
        child: _tile(),
      ),
    );
  }
}
