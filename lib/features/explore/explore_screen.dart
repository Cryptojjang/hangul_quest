/// Explore Korea — travel apps, history, food and (web only) our saju
/// readings. Free; content lives in core/data/explore.dart.
library;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/data/explore.dart';
import '../../theme/hq_theme.dart';

Future<void> _open(BuildContext context, String url) async {
  final ok =
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Could not open $url')));
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Store builds must not link out to buy digital services (App Review
    // 3.1.1), so the saju tab exists on the web build only.
    final tabs = [
      ('Apps', const _AppsTab()),
      ('History', const _HistoryTab()),
      ('Food', const _FoodTab()),
      if (kIsWeb) ('Saju', const _SajuTab()),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: HqColors.ink,
          title: const Text('Explore Korea · 한국 둘러보기'),
          bottom: TabBar(
            labelColor: HqColors.ink,
            unselectedLabelColor: HqColors.inkSoft,
            indicatorColor: HqColors.dancheongRed,
            labelStyle: const TextStyle(fontWeight: FontWeight.w800),
            tabs: [for (final (label, _) in tabs) Tab(text: label)],
          ),
        ),
        body: TabBarView(children: [for (final (_, tab) in tabs) tab]),
      ),
    );
  }
}

class _AppsTab extends StatelessWidget {
  const _AppsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Install these before you fly — they make Korea easy.',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        for (final a in travelApps)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: HqCard(
              onTap: () => _open(context, a.url),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('${a.name} · ${a.nameKo}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800)),
                      ),
                      const Icon(Icons.open_in_new_rounded,
                          size: 18, color: HqColors.inkSoft),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(a.useFor, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text('Tip: ${a.tip}',
                      style: const TextStyle(
                          fontSize: 13, color: HqColors.dancheongBlue)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('5,000 years in 11 stops.',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        for (var i = 0; i < koreanHistory.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Timeline rail: dot + connecting line.
                SizedBox(
                  width: 24,
                  child: Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: const BoxDecoration(
                            color: HqColors.dancheongRed,
                            shape: BoxShape.circle),
                      ),
                      if (i < koreanHistory.length - 1)
                        Expanded(
                          child: Container(
                              width: 2,
                              color: HqColors.celadon.withValues(alpha: 0.7)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(koreanHistory[i].years,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: HqColors.inkSoft)),
                        Text(
                            '${koreanHistory[i].era} · ${koreanHistory[i].eraKo}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text(koreanHistory[i].story,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(height: 1.5)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FoodTab extends StatelessWidget {
  const _FoodTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
            'Must-try dishes. Tap a map button to see top-rated places '
            'near you right now — live ratings, never out of date.',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        for (final f in foodPicks)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: HqCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${f.dishKo} · ${f.dish}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(f.why, style: Theme.of(context).textTheme.bodyMedium),
                  Text('Where: ${f.whereToTry}',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _LinkChip(
                          label: 'Naver Map',
                          onTap: () => _open(context, f.naverMapUrl)),
                      _LinkChip(
                          label: 'Google Maps',
                          onTap: () => _open(context, f.googleMapsUrl)),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SajuTab extends StatelessWidget {
  const _SajuTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
            'Saju (사주) is Korean fortune reading from the "four pillars" of '
            'your birth year, month, day and hour. Couples check their '
            'compatibility — 궁합 — before big decisions.',
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
        const SizedBox(height: 12),
        for (final s in sajuLinks)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: HqCard(
              onTap: () => _open(context, s.url),
              child: Row(
                children: [
                  const HqIconTile(
                      icon: Icons.auto_awesome_rounded,
                      color: HqColors.obangYellow),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text(s.description,
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 4),
                        const Text('View on Etsy',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: HqColors.dancheongRed)),
                      ],
                    ),
                  ),
                  const Icon(Icons.open_in_new_rounded,
                      size: 18, color: HqColors.inkSoft),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _LinkChip extends StatelessWidget {
  const _LinkChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: HqColors.celadon.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.place_rounded, size: 16, color: HqColors.ink),
            const SizedBox(width: 4),
            Text(label,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
