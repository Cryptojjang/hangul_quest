/// Learn Hangul — the free course (lib/core/data/lessons.dart): every
/// consonant and vowel with sound, syllable building, final consonants and
/// reading rules. Complements the game stages, which practise what is
/// taught here.
library;

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/data/lessons.dart';
import '../../core/hangul/hangul.dart';
import '../../l10n/l10n.dart';
import '../../theme/hq_theme.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: Text(context.l.learnTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Text(context.l.learnIntro,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          for (var i = 0; i < hangulCourse.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LessonCard(index: i),
            ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final lesson = hangulCourse[index];
    return HqCard(
      onTap: () => Navigator.of(context)
          .push(HqPageRoute(page: LessonScreen(index: index))),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: HqColors.dancheongBlue, shape: BoxShape.circle),
            child: Text('${index + 1}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${lesson.title} · ${lesson.titleKo}',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(lesson.summary,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: HqColors.inkSoft),
        ],
      ),
    );
  }
}

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final lesson = hangulCourse[index];
    final hasNext = index + 1 < hangulCourse.length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: HqColors.ink,
        title: Text('${index + 1}. ${lesson.title}'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          Text(lesson.titleKo,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: HqColors.dancheongRed)),
          const SizedBox(height: 8),
          for (final block in lesson.blocks)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _Block(block: block),
            ),
          HqButton(
            label: hasNext
                ? context.l.learnNext(hangulCourse[index + 1].title)
                : context.l.learnBackToLessons,
            expanded: true,
            color: hasNext ? HqColors.dancheongRed : HqColors.dancheongBlue,
            onPressed: () => hasNext
                ? Navigator.of(context).pushReplacement(
                    HqPageRoute(page: LessonScreen(index: index + 1)))
                : Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.block});

  final LessonBlock block;

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).textTheme.bodyMedium;
    return switch (block) {
      LessonText(:final text) =>
        Text(text, style: body?.copyWith(height: 1.55)),
      LessonCallout(:final text) => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: HqColors.obangYellow.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: HqColors.obangYellow.withValues(alpha: 0.5)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_rounded,
                  size: 20, color: HqColors.obangYellow),
              const SizedBox(width: 8),
              Expanded(child: Text(text, style: body?.copyWith(height: 1.5))),
            ],
          ),
        ),
      LessonJamo(:final ids) => Column(
          children: [
            for (final id in ids)
              if (jamoById[id] case final jamo?) _JamoRow(jamo: jamo),
          ],
        ),
      LessonTable(:final header, :final rows) =>
        _LessonTableView(header: header, rows: rows),
      LessonExamples(:final title, :final items) =>
        _ExamplesView(title: title, items: items),
      LessonComposer() => const _Composer(),
    };
  }
}

class _JamoRow extends StatelessWidget {
  const _JamoRow({required this.jamo});

  final Jamo jamo;

  @override
  Widget build(BuildContext context) {
    final tip = jamoTipsEn[jamo.id];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: HqCard(
        padding: const EdgeInsets.all(12),
        onTap: () => AppScope.of(context).playJamo(jamo),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: HqColors.blockColorFor(jamo.role.index)
                    .withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(jamo.char,
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: HqColors.ink)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${jamo.romanization}  ·  ${jamo.nameKo}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  if (tip != null)
                    Text(tip, style: Theme.of(context).textTheme.bodySmall),
                  if (jamo.exampleWords.isNotEmpty)
                    Text(context.l.learnExample(jamo.exampleWords.join(', ')),
                        style: const TextStyle(
                            fontSize: 13, color: HqColors.dancheongBlue)),
                ],
              ),
            ),
            const Icon(Icons.volume_up_rounded, color: HqColors.inkSoft),
          ],
        ),
      ),
    );
  }
}

class _LessonTableView extends StatelessWidget {
  const _LessonTableView({required this.header, required this.rows});

  final List<String> header;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    Widget cell(String s, {bool head = false}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(s,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: head ? FontWeight.w800 : FontWeight.w600,
                  color: head ? HqColors.inkSoft : HqColors.ink)),
        );
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Table(
        border: TableBorder.symmetric(
            inside: BorderSide(color: HqColors.ink.withValues(alpha: 0.08))),
        children: [
          TableRow(
            decoration:
                BoxDecoration(color: HqColors.celadon.withValues(alpha: 0.4)),
            children: [for (final h in header) cell(h, head: true)],
          ),
          for (final r in rows)
            TableRow(
              decoration: const BoxDecoration(color: Colors.white),
              children: [for (final c in r) cell(c)],
            ),
        ],
      ),
    );
  }
}

class _ExamplesView extends StatelessWidget {
  const _ExamplesView({required this.title, required this.items});

  final String title;
  final List<(String, String, String)> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        for (final (written, sounds, meaning) in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  child: Text(written,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800)),
                ),
                Expanded(
                  child: Text(sounds,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: HqColors.dancheongBlue)),
                ),
                Text(meaning, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
      ],
    );
  }
}

/// Pick a first consonant, a vowel and an optional final; the block, its
/// shape and its sound (romanization) update live. Tapping a letter plays it.
class _Composer extends StatefulWidget {
  const _Composer();

  @override
  State<_Composer> createState() => _ComposerState();
}

class _ComposerState extends State<_Composer> {
  int _initial = 0; // ㄱ
  int _vowel = 0; // ㅏ
  int _final = 0; // none

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final s = compose(_initial, _vowel, _final);
    final l = context.l;
    final shape = switch (layoutForJungseong(_vowel)) {
      SyllableLayout.vertical => l.learnLayoutTall,
      SyllableLayout.horizontal => l.learnLayoutFlat,
      SyllableLayout.mixed => l.learnLayoutMixed,
    };

    Widget picker(
        String label, List<Jamo> table, int selected, void Function(int) onPick,
        {bool allowNone = false}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (allowNone)
                _Chip(
                    text: '—',
                    selected: selected == 0,
                    color: HqColors.jongseongBlock,
                    onTap: () => onPick(0)),
              for (final j in table)
                _Chip(
                  text: j.char,
                  selected: selected == j.index,
                  color: HqColors.blockColorFor(j.role.index),
                  onTap: () {
                    onPick(j.index);
                    // Finals have no voice slot of their own; initials and
                    // vowels do.
                    if (j.role != JamoRole.jongseong) state.playJamo(j);
                  },
                ),
            ],
          ),
        ],
      );
    }

    return HqCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(s.char,
                style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w800,
                    color: HqColors.ink)),
          ),
          Center(
            child: Text('[${romanizeSyllable(s)}]',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: HqColors.dancheongBlue)),
          ),
          Center(
            child: Text(shape, style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(height: 14),
          picker(l.learnPickInitial, choseongTable, _initial,
              (i) => setState(() => _initial = i)),
          const SizedBox(height: 12),
          picker(l.learnPickVowel, jungseongTable, _vowel,
              (i) => setState(() => _vowel = i)),
          const SizedBox(height: 12),
          picker(l.learnPickFinal, jongseongTable, _final,
              (i) => setState(() => _final = i),
              allowNone: true),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.text,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? HqColors.ink : Colors.transparent, width: 2),
        ),
        child: Text(text,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: HqColors.ink)),
      ),
    );
  }
}
