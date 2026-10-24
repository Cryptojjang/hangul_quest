/// Explore Korea — travel apps, history, food and (web only) our saju
/// readings. Free; content lives in core/data/explore.dart.
library;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/data/content_keys.dart';
import '../../core/data/explore.dart';
import '../../l10n/l10n.dart';
import '../../theme/hq_theme.dart';

Future<void> _open(BuildContext context, String url) async {
  final ok =
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l.commonCouldNotOpen(url))));
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Store builds must not link out to buy digital services (App Review
    // 3.1.1), so the saju tab exists on the web build only.
    final l = context.l;
    final tabs = [
      (l.exploreTabApps, const _AppsTab()),
      (l.exploreTabHistory, const _HistoryTab()),
      (l.exploreTabFood, const _FoodTab()),
      if (kIsWeb) (l.exploreTabSaju, const _SajuTab()),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: HqColors.ink,
          title: Text(l.exploreTitle),
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
        Text(context.l.exploreAppsIntro,
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        for (final (i, a) in travelApps.indexed)
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
                  Text(ct(context.localeCode, appKey(i, 'useFor'), a.useFor),
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(
                      context.l.exploreTip(
                          ct(context.localeCode, appKey(i, 'tip'), a.tip)),
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
        Text(context.l.exploreHistoryIntro,
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
                        Text(
                            ct(context.localeCode, historyKey(i, 'years'),
                                koreanHistory[i].years),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: HqColors.inkSoft)),
                        Text(
                            '${ct(context.localeCode, historyKey(i, 'era'), koreanHistory[i].era)}'
                            ' · ${koreanHistory[i].eraKo}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text(
                            ct(context.localeCode, historyKey(i, 'story'),
                                koreanHistory[i].story),
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
        Text(context.l.exploreFoodIntro,
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        // Google Maps links open in English (hl=en). Naver has no verified
        // URL language switch; its app follows this setting instead.
        Text(context.l.exploreNaverEnglish,
            style:
                const TextStyle(fontSize: 13, color: HqColors.dancheongBlue)),
        const SizedBox(height: 12),
        for (final (i, f) in foodPicks.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: HqCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${f.dishKo} · '
                      '${ct(context.localeCode, foodKey(i, 'dish'), f.dish)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(ct(context.localeCode, foodKey(i, 'why'), f.why),
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                      context.l.exploreWhere(ct(context.localeCode,
                          foodKey(i, 'where'), f.whereToTry)),
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
        Text(context.l.exploreSajuIntro,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
        const SizedBox(height: 12),
        for (final (i, s) in sajuLinks.indexed)
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
                        Text(
                            ct(context.localeCode, sajuKey(i, 'title'),
                                s.title),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text(
                            ct(context.localeCode, sajuKey(i, 'desc'),
                                s.description),
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 4),
                        Text(context.l.exploreViewOnEtsy,
                            style: const TextStyle(
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
