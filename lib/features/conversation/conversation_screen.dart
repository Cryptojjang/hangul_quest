/// Real-life Korean: situational conversations (core/data/conversations.dart).
/// The first few are a free taster; locked ones route to the paywall.
library;

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/data/conversations.dart';
import '../../platform/audio/audio_asset_manager.dart';
import '../../theme/hq_theme.dart';
import '../paywall/paywall_screen.dart';

class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: const Text('Real-life Korean · 상황별 대화'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Text(
              'Phrases for the moments you will actually be in — tap any line '
              'to hear it.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          for (var i = 0; i < conversations.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ConversationCard(
                index: i,
                locked: !state.gate
                    .canOpenConversation(state.entitlements, i)
                    .allowed,
              ),
            ),
        ],
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  const _ConversationCard({required this.index, required this.locked});

  final int index;
  final bool locked;

  void _open(BuildContext context) {
    final state = AppScope.of(context);
    final decision = state.gate.canOpenConversation(state.entitlements, index);
    if (!decision.allowed) {
      PaywallScreen.show(context,
          trigger: state.gate.paywallTriggerFor(decision.reason)!);
      return;
    }
    Navigator.of(context)
        .push(HqPageRoute(page: ConversationScreen(index: index)));
  }

  @override
  Widget build(BuildContext context) {
    final c = conversations[index];
    final free = index < freeConversationCount;
    return HqCard(
      color: locked ? const Color(0xFFEFE9DC) : Colors.white,
      onTap: () => _open(context),
      child: Row(
        children: [
          HqIconTile(
            icon: Icons.forum_rounded,
            color: locked ? HqColors.inkSoft : HqColors.dancheongBlue,
            size: 44,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.title,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(c.titleKo, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (free)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: HqColors.dancheongGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('FREE',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
            )
          else if (locked)
            const Icon(Icons.lock_rounded, size: 18, color: HqColors.inkSoft)
          else
            const Icon(Icons.chevron_right_rounded, color: HqColors.inkSoft),
        ],
      ),
    );
  }
}

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, required this.index});

  final int index;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  bool _showRoman = true;

  void _play(String slot) =>
      AppScope.of(context).services.audio.playVoice(AudioSlots.phrase(slot));

  @override
  Widget build(BuildContext context) {
    final c = conversations[widget.index];
    // Speakers alternate sides in order of first appearance.
    final speakers = <String>[];
    for (final l in c.lines) {
      if (!speakers.contains(l.speaker)) speakers.add(l.speaker);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: Text(c.title),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        children: [
          Text(c.titleKo,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: HqColors.dancheongRed)),
          const SizedBox(height: 4),
          Text(c.situation, style: Theme.of(context).textTheme.bodyMedium),
          Row(
            children: [
              const Spacer(),
              Text('Romanization',
                  style: Theme.of(context).textTheme.bodySmall),
              Switch(
                value: _showRoman,
                activeColor: HqColors.dancheongBlue,
                onChanged: (v) => setState(() => _showRoman = v),
              ),
            ],
          ),
          for (var i = 0; i < c.lines.length; i++)
            _Bubble(
              line: c.lines[i],
              right: speakers.indexOf(c.lines[i].speaker).isOdd,
              showRoman: _showRoman,
              onTap: () => _play(c.lineSlot(i)),
            ),
          const SizedBox(height: 16),
          const Text('Key phrases',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          for (var i = 0; i < c.phrases.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: HqCard(
                padding: const EdgeInsets.all(12),
                onTap: () => _play(c.phraseSlot(i)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.phrases[i].korean,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800)),
                          if (_showRoman)
                            Text(c.phrases[i].romanization,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: HqColors.dancheongBlue)),
                          Text(c.phrases[i].english,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    const Icon(Icons.volume_up_rounded,
                        color: HqColors.inkSoft),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: HqColors.obangYellow.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: HqColors.obangYellow.withValues(alpha: 0.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.public_rounded,
                    size: 20, color: HqColors.obangYellow),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Culture tip',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(c.cultureTip,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.line,
    required this.right,
    required this.showRoman,
    required this.onTap,
  });

  final DialogueLine line;
  final bool right;
  final bool showRoman;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        right ? HqColors.jungseongBlock.withValues(alpha: 0.45) : Colors.white;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment:
            right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(line.speaker,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: HqColors.inkSoft)),
          ),
          const SizedBox(height: 2),
          GestureDetector(
            onTap: onTap,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 320),
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(right ? 18 : 4),
                  bottomRight: Radius.circular(right ? 4 : 18),
                ),
                border: Border.all(color: HqColors.ink.withValues(alpha: 0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(line.korean,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.volume_up_rounded,
                          size: 16, color: HqColors.inkSoft),
                    ],
                  ),
                  if (showRoman)
                    Text(line.romanization,
                        style: const TextStyle(
                            fontSize: 13, color: HqColors.dancheongBlue)),
                  Text(line.english,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
