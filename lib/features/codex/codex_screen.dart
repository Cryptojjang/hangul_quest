/// Jamo Codex — collectible cards unlocked through play (spec §4.1).
/// Card detail: native audio, sound-shape principle, stroke order slot,
/// example words. Mastered cards get the celadon-glaze tier.
library;

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/hangul/hangul.dart';
import '../../theme/hq_theme.dart';

class CodexScreen extends StatelessWidget {
  const CodexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final all = [...choseongTable, ...jungseongTable, ...jongseongTable];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: Text('자모 도감  ${state.progress.codex.length}/${all.length}'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3 / 4,
        children: [
          for (final jamo in all)
            _CodexCard(
              jamo: jamo,
              tier: state.progress.codex[jamo.id] ?? 0,
            ),
        ],
      ),
    );
  }
}

class _CodexCard extends StatelessWidget {
  const _CodexCard({required this.jamo, required this.tier});

  final Jamo jamo;

  /// 0 = locked, 1 = unlocked, 2 = mastered.
  final int tier;

  @override
  Widget build(BuildContext context) {
    final locked = tier == 0;
    return GestureDetector(
      onTap: locked
          ? null
          : () => showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => _CardDetail(jamo: jamo, tier: tier),
              ),
      child: Container(
        decoration: BoxDecoration(
          color: locked
              ? const Color(0xFFE9E2D2)
              : (tier == 2 ? HqColors.celadon : Colors.white),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: tier == 2
                  ? HqColors.obangYellow
                  : HqColors.ink.withValues(alpha: 0.08),
              width: tier == 2 ? 2 : 1),
          boxShadow: locked
              ? const []
              : const [BoxShadow(color: Color(0x1A2B2622), offset: Offset(2, 3))],
          gradient: tier == 2
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HqColors.celadon,
                    HqColors.celadon.withValues(alpha: 0.6),
                    Colors.white,
                  ],
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              locked ? '?' : jamo.char,
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                color: locked ? HqColors.inkSoft : HqColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(locked ? '미발견' : jamo.nameKo,
                style: const TextStyle(
                    fontSize: 11, color: HqColors.inkSoft)),
            if (tier == 2)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text('★ 마스터',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: HqColors.obangYellow)),
              ),
          ],
        ),
      ),
    );
  }
}

class _CardDetail extends StatelessWidget {
  const _CardDetail({required this.jamo, required this.tier});

  final Jamo jamo;
  final int tier;

  String get _principle {
    if (jamo.articulator != null) {
      return switch (jamo.articulator!) {
        Articulator.velar => '혀뿌리가 목구멍을 막는 모양을 본떴어요',
        Articulator.alveolar => '혀끝이 윗잇몸에 닿는 모양을 본떴어요',
        Articulator.labial => '입술 모양을 본떴어요',
        Articulator.dental => '이(치아)의 모양을 본떴어요',
        Articulator.glottal => '목구멍의 모양을 본떴어요',
      };
    }
    if (jamo.cheonjiin != null) {
      return '하늘(ㆍ)·땅(ㅡ)·사람(ㅣ)의 조합: ${jamo.cheonjiin}';
    }
    return '받침 자리에서 나는 소리예요';
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: HqColors.hanji,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 140,
            height: 180,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tier == 2 ? HqColors.celadon : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: tier == 2
                      ? HqColors.obangYellow
                      : HqColors.ink.withValues(alpha: 0.1),
                  width: 2),
              boxShadow: const [
                BoxShadow(color: Color(0x262B2622), offset: Offset(3, 4))
              ],
            ),
            // Sound-shape + stroke-order animation slot (art pipeline).
            child: Text(jamo.char,
                style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w800,
                    color: HqColors.ink)),
          ),
          const SizedBox(height: 16),
          Text('${jamo.nameKo}  ·  ${jamo.romanization}',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(_principle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          if (jamo.exampleWords.isNotEmpty)
            Wrap(
              spacing: 8,
              children: [
                for (final w in jamo.exampleWords)
                  Chip(
                    backgroundColor: Colors.white,
                    label: Text(w),
                    side: BorderSide(
                        color: HqColors.ink.withValues(alpha: 0.1)),
                  ),
              ],
            ),
          const SizedBox(height: 16),
          HqButton(
            label: '🔊 발음 듣기',
            color: HqColors.dancheongBlue,
            onPressed: () => state.playJamo(jamo),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
