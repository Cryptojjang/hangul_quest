/// Jamo Codex — collectible cards unlocked through play (spec §4.1).
/// Card detail: native audio, sound-shape principle, stroke order slot,
/// example words. Mastered cards get the celadon-glaze tier.
library;

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/hangul/hangul.dart';
import '../../l10n/l10n.dart';
import '../../theme/hq_theme.dart';

class CodexScreen extends StatelessWidget {
  const CodexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final codex = state.progress.codex;
    final l = context.l;
    // Grouped by role so the 67 cards read as three sets to complete,
    // not one undifferentiated wall.
    final sections = [
      (l.codexInitials, '첫소리', choseongTable),
      (l.codexVowels, '가운뎃소리', jungseongTable),
      (l.codexFinals, '받침', jongseongTable),
    ];
    final total = sections.fold(0, (n, s) => n + s.$3.length);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: Text(l.codexTitle(codex.length, total)),
      ),
      body: CustomScrollView(
        slivers: [
          if (codex.isEmpty)
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
              sliver: SliverToBoxAdapter(child: _EmptyHint()),
            ),
          for (final (title, subtitle, table) in sections) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                  title: title,
                  subtitle: subtitle,
                  found: table.where((j) => codex.containsKey(j.id)).length,
                  total: table.length,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3 / 4,
                children: [
                  for (final jamo in table)
                    _CodexCard(jamo: jamo, tier: codex[jamo.id] ?? 0),
                ],
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();

  @override
  Widget build(BuildContext context) {
    return HqCard(
      color: HqColors.celadon.withValues(alpha: 0.35),
      child: Row(
        children: [
          const HqIconTile(icon: Icons.style_rounded, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Text(context.l.codexEmptyHint,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.found,
    required this.total,
  });

  final String title;
  final String subtitle;
  final int found;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(width: 8),
        Expanded(
          child: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ),
        Text('$found/$total',
            style: const TextStyle(
                fontWeight: FontWeight.w800, color: HqColors.dancheongGreen)),
      ],
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
              : const [
                  BoxShadow(color: Color(0x1A2B2622), offset: Offset(2, 3))
                ],
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
            // Locked cards show a faint silhouette — a sticker-album gap that
            // invites collecting, instead of a wall of identical "?".
            Text(
              jamo.char,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: locked
                    ? HqColors.ink.withValues(alpha: 0.12)
                    : HqColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(locked ? context.l.codexLocked : jamo.nameKo,
                style: const TextStyle(fontSize: 11, color: HqColors.inkSoft)),
            if (tier == 2)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(context.l.codexMastered,
                    style: const TextStyle(
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

  String _principle(L10n l) {
    if (jamo.articulator != null) {
      return switch (jamo.articulator!) {
        Articulator.velar => l.codexVelar,
        Articulator.alveolar => l.codexAlveolar,
        Articulator.labial => l.codexLabial,
        Articulator.dental => l.codexDental,
        Articulator.glottal => l.codexGlottal,
      };
    }
    if (jamo.cheonjiin != null) {
      return l.codexCheonjiin(jamo.cheonjiin!);
    }
    return l.codexFinalSound;
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
          Text(_principle(context.l),
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
                    side:
                        BorderSide(color: HqColors.ink.withValues(alpha: 0.1)),
                  ),
              ],
            ),
          const SizedBox(height: 16),
          HqButton(
            label: context.l.codexHearIt,
            icon: Icons.volume_up_rounded,
            color: HqColors.dancheongBlue,
            onPressed: () => state.playJamo(jamo),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
