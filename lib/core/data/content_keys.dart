/// Translation keys for learning content (Learn lessons + Explore guide).
///
/// English stays in the data files as the source of truth; translations are
/// looked up by stable keys and fall back to English when missing. The
/// English key → text table is exported by tool/export_content_en.dart;
/// translated JSON (lib/l10n/content/content_<code>.json) is compiled into
/// content_translations.g.dart by tool/gen_content_i18n.dart.
library;

import 'content_translations.g.dart';
import 'conversations.dart';
import 'curriculum.dart';
import 'explore.dart';
import 'lessons.dart';
import 'vocab.dart';

/// Looks up translated content for [locale] (e.g. "ja", "zh_TW").
String ct(String locale, String key, String english) =>
    contentTranslations[locale]?[key] ?? english;

/// Only strings with English words need translating; table cells such as
/// "ㄱ g" or "가" are left alone.
bool hasEnglish(String s) => RegExp(r'[A-Za-z]{3,}').hasMatch(s);

// -- key builders (shared by the screens and the exporter) -----------------

String lessonKey(String lessonId, String part) => 'lesson.$lessonId.$part';
String blockKey(String lessonId, int block) => 'lesson.$lessonId.$block';
String headerKey(String lessonId, int block, int col) =>
    'lesson.$lessonId.$block.h$col';
String cellKey(String lessonId, int block, int row, int col) =>
    'lesson.$lessonId.$block.r$row.$col';
String examplesTitleKey(String lessonId, int block) =>
    'lesson.$lessonId.$block.title';
String exampleMeaningKey(String lessonId, int block, int item) =>
    'lesson.$lessonId.$block.e$item';
String tipKey(String jamoId) => 'tip.$jamoId';

String appKey(int i, String part) => 'app.$i.$part';
String historyKey(int i, String part) => 'hist.$i.$part';
String foodKey(int i, String part) => 'food.$i.$part';
String sajuKey(int i, String part) => 'saju.$i.$part';

String convKey(String convId, String part) => 'conv.$convId.$part';
String convLineKey(String convId, int i) => 'conv.$convId.l$i';
String convSpeakerKey(String convId, int i) => 'conv.$convId.s$i';
String convPhraseKey(String convId, int i) => 'conv.$convId.k$i';
String wordKey(String wordId) => 'word.$wordId';
String levelKey(StageId stage, int level) => 'level.${stage.name}.$level';

/// Every translatable content string, keyed — the translation source.
Map<String, String> englishContent() {
  final out = <String, String>{};
  for (final lesson in hangulCourse) {
    out[lessonKey(lesson.id, 'title')] = lesson.title;
    out[lessonKey(lesson.id, 'summary')] = lesson.summary;
    for (var b = 0; b < lesson.blocks.length; b++) {
      switch (lesson.blocks[b]) {
        case LessonText(:final text) || LessonCallout(:final text):
          out[blockKey(lesson.id, b)] = text;
        case LessonTable(:final header, :final rows):
          for (var c = 0; c < header.length; c++) {
            if (hasEnglish(header[c])) {
              out[headerKey(lesson.id, b, c)] = header[c];
            }
          }
          for (var r = 0; r < rows.length; r++) {
            for (var c = 0; c < rows[r].length; c++) {
              if (hasEnglish(rows[r][c])) {
                out[cellKey(lesson.id, b, r, c)] = rows[r][c];
              }
            }
          }
        case LessonExamples(:final title, :final items):
          out[examplesTitleKey(lesson.id, b)] = title;
          for (var k = 0; k < items.length; k++) {
            out[exampleMeaningKey(lesson.id, b, k)] = items[k].$3;
          }
        case LessonJamo() || LessonComposer():
          break;
      }
    }
  }
  for (final e in jamoTipsEn.entries) {
    out[tipKey(e.key)] = e.value;
  }
  for (var i = 0; i < travelApps.length; i++) {
    out[appKey(i, 'useFor')] = travelApps[i].useFor;
    out[appKey(i, 'tip')] = travelApps[i].tip;
  }
  for (var i = 0; i < koreanHistory.length; i++) {
    out[historyKey(i, 'era')] = koreanHistory[i].era;
    out[historyKey(i, 'years')] = koreanHistory[i].years;
    out[historyKey(i, 'story')] = koreanHistory[i].story;
  }
  for (var i = 0; i < foodPicks.length; i++) {
    out[foodKey(i, 'dish')] = foodPicks[i].dish;
    out[foodKey(i, 'why')] = foodPicks[i].why;
    out[foodKey(i, 'where')] = foodPicks[i].whereToTry;
  }
  for (var i = 0; i < sajuLinks.length; i++) {
    out[sajuKey(i, 'title')] = sajuLinks[i].title;
    out[sajuKey(i, 'desc')] = sajuLinks[i].description;
  }
  for (final c in conversations) {
    out[convKey(c.id, 'title')] = c.title;
    out[convKey(c.id, 'situation')] = c.situation;
    out[convKey(c.id, 'tip')] = c.cultureTip;
    for (var i = 0; i < c.lines.length; i++) {
      out[convLineKey(c.id, i)] = c.lines[i].english;
      // Role labels ("Staff", "To a stranger") translate; short names
      // like "A"/"B" don't need to.
      if (hasEnglish(c.lines[i].speaker)) {
        out[convSpeakerKey(c.id, i)] = c.lines[i].speaker;
      }
    }
    for (var i = 0; i < c.phrases.length; i++) {
      out[convPhraseKey(c.id, i)] = c.phrases[i].english;
    }
  }
  for (final w in vocabWords) {
    out[wordKey(w.id)] = w.english;
  }
  for (final stage in StageId.values) {
    for (final l in levelsFor(stage)) {
      if (hasEnglish(l.title)) out[levelKey(stage, l.level)] = l.title;
    }
  }
  return out;
}
