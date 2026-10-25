// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class L10nDe extends L10n {
  L10nDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Hangul Bricks';

  @override
  String get language => 'Sprache';

  @override
  String get languageFollowDevice => 'Gerätesprache';

  @override
  String get commonNext => 'Weiter';

  @override
  String get commonSkip => 'Überspringen';

  @override
  String get commonPlay => 'Spielen';

  @override
  String get commonGo => 'Los';

  @override
  String get commonBackToMap => 'Zurück zur Karte';

  @override
  String get commonFree => 'GRATIS';

  @override
  String get commonRestorePurchase => 'Kauf wiederherstellen';

  @override
  String get commonPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get commonTermsOfUse => 'Nutzungsbedingungen';

  @override
  String get commonManageSubscription => 'Abo verwalten';

  @override
  String get commonReadFullText => 'Volltext lesen';

  @override
  String get commonSummary => 'Zusammenfassung';

  @override
  String get commonSubscriptionRestored => 'Abo wiederhergestellt';

  @override
  String get commonNoSubscription => 'Kein Abo zum Wiederherstellen';

  @override
  String get restoreEmailAction => 'Per E-Mail wiederherstellen';

  @override
  String get restoreEmailBody =>
      'Gib die E-Mail-Adresse ein, die du beim Kauf verwendet hast. Wir schicken dir einen Einmalcode.';

  @override
  String get restoreEmailField => 'E-Mail';

  @override
  String get restoreEmailSend => 'Code senden';

  @override
  String get restoreEmailSent =>
      'Falls zu dieser E-Mail ein Kauf gehört, ist ein Code unterwegs. Sieh in deinem Posteingang (und Spam-Ordner) nach.';

  @override
  String get restoreEmailCodeField => 'Code';

  @override
  String get restoreEmailConfirm => 'Wiederherstellen';

  @override
  String get restoreEmailBadCode => 'Der Code ist falsch oder abgelaufen.';

  @override
  String get restoreEmailError =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String commonCouldNotOpen(String url) {
    return '$url konnte nicht geöffnet werden';
  }

  @override
  String get onbHookTitle =>
      'Lies die Songs, die du liebst,\nin ihrer eigenen Schrift';

  @override
  String get onbHookBody =>
      'Hangul ist die am leichtesten zu lernende Schrift der Welt — die Buchstaben stecken zusammen wie Bausteine.';

  @override
  String get onbPromiseTitle => 'Hangul lesen\nin 7 Tagen';

  @override
  String get onbPromiseFooter => 'Einfach spielen. Den Rest machen wir.';

  @override
  String get onbNotifTitle => '5 Minuten am Tag\nhalten deine Serie am Leben';

  @override
  String get onbNotifBody =>
      'Möchtest du abends eine sanfte Erinnerung? Ganz freiwillig.';

  @override
  String get onbAllowReminders => 'Erinnerungen erlauben';

  @override
  String get onbGetStarted => 'Los geht\'s';

  @override
  String get onbChooseLanguage => 'Wähle deine Sprache';

  @override
  String trackerHeader(int day) {
    return 'HANGUL LESEN IN 7 TAGEN · TAG $day';
  }

  @override
  String get trackerDay1Title => 'Lerne die Konsonanten kennen';

  @override
  String get trackerDay1Goal => '10 Grundkonsonanten erkennen';

  @override
  String get trackerDay2Title => 'So funktionieren Vokale';

  @override
  String get trackerDay2Goal => '6 Grundvokale + deine erste Silbe';

  @override
  String get trackerDay3Title => 'Bausteine';

  @override
  String get trackerDay3Goal => 'Senkrechte & waagerechte Vokale stapeln';

  @override
  String get trackerDay4Title => 'Endkonsonanten';

  @override
  String get trackerDay4Goal => 'Silben mit Batchim';

  @override
  String get trackerDay5Title => 'Knifflige Laute';

  @override
  String get trackerDay5Goal => 'Gespannte & aspirierte Konsonanten';

  @override
  String get trackerDay6Title => 'Wörter lesen';

  @override
  String get trackerDay6Goal => 'Lies deine ersten 12 Wörter';

  @override
  String get trackerDay7Title => 'Fließend lesen';

  @override
  String get trackerDay7Goal => 'Jede Silbe entziffern';

  @override
  String get homeLearnTitle => 'Hangul lernen · 한글 배우기';

  @override
  String get homeLearnSubtitle =>
      'Von jedem Buchstaben bis zu den Leseregeln · 8 Gratis-Lektionen';

  @override
  String get homeTalkTitle => 'Koreanisch im Alltag · 상황별 대화';

  @override
  String get homeTalkSubtitlePremium =>
      'Café, Taxi, K-Dramas, Fan-Events und mehr';

  @override
  String get homeTalkSubtitleFree => '3 Gratis-Gespräche · mehr mit Premium';

  @override
  String get homeExploreTitle => 'Korea entdecken · 한국 둘러보기';

  @override
  String get homeExploreSubtitle =>
      'Reise-Apps, Geschichte und Gerichte zum Probieren';

  @override
  String get homeDailyTitle => 'Tages-Challenge';

  @override
  String get homeDailySubtitle =>
      'Halte deine Serie mit einer gemischten Runde';

  @override
  String get homeStages => 'Stufen';

  @override
  String get homeCodex => 'Buchstaben-Codex';

  @override
  String homeCodexCount(int count) {
    return '$count / 67 Karten';
  }

  @override
  String get homeReview => 'Smarte Wiederholung';

  @override
  String get homeReviewUnlimited => 'Unbegrenzt';

  @override
  String homeReviewFreeToday(int used) {
    return 'Heute gratis $used/1';
  }

  @override
  String get homeLeague => 'Wochenliga · Seladon';

  @override
  String get homeLeagueYou => 'Du';

  @override
  String get homeSpeechUnsupported =>
      'Aussprache wird auf diesem Gerät nicht unterstützt';

  @override
  String get homeNotSupported => 'Auf diesem Gerät nicht unterstützt';

  @override
  String get stageJamoHunt => 'Jamo-Jagd';

  @override
  String get stageJamoHuntSub => 'Hör einen Laut, tipp den Buchstaben';

  @override
  String get stageLetterBuilder => 'Silbenbau';

  @override
  String get stageLetterBuilderSub => 'Steck Buchstaben zu Silben zusammen';

  @override
  String get stageWordRush => 'Wort-Sprint';

  @override
  String get stageWordRushSub => 'Lies Wörter, finde die Bilder';

  @override
  String get stagePronunciation => 'Aussprache';

  @override
  String get stagePronunciationSub => 'Lass deine Aussprache bewerten';

  @override
  String get miniJamoTitle => 'Buchstaben, die Laute zeichnen';

  @override
  String get miniJamoBody =>
      'ㄱ zeigt die Zunge, die den Rachen blockiert, ㅁ zeigt die Lippen.\nKoreanische Konsonanten sind Bilder deines Mundes.';

  @override
  String get miniJamoPrompt => 'Tippen, um den Laut zu hören';

  @override
  String get miniBuilderTitle => 'Warum stapelt sich Hangul wie Bausteine?';

  @override
  String get miniBuilderBody =>
      'Anlaut, Vokal und Auslaut stapeln sich zu einem Block.\nDie Form des Vokals bestimmt die Anordnung.';

  @override
  String get miniBuilderPrompt => 'Tippen, um die Silbe zu bauen';

  @override
  String get miniWordTitle => 'Jetzt echte Wörter lesen';

  @override
  String get miniWordBody =>
      'Was du bauen kannst, kannst du auch lesen.\nLies schnell und wähle das passende Bild.';

  @override
  String get miniWordPrompt => 'Tippen, um das Wort zu bilden';

  @override
  String get miniSpeakTitle => 'Bereit, es laut zu sagen?';

  @override
  String get miniSpeakBody =>
      'Zum Schluss wird gesprochen. Sag es ins Mikro und\nwir bewerten, welche Laute du getroffen hast.';

  @override
  String get miniSpeakPrompt => 'Tippen, um erst zuzuhören';

  @override
  String get miniSkip => 'Überspringen →';

  @override
  String miniStartsIn(int seconds) {
    return 'Start in $seconds s';
  }

  @override
  String get miniTapToReplay => 'Tippen zum Wiederholen';

  @override
  String get jamoHuntPrompt => 'Finde den Buchstaben zu diesem Laut';

  @override
  String comboActive(int multiplier, int combo) {
    return 'x$multiplier Combo $combo';
  }

  @override
  String comboIdle(int combo) {
    return 'Combo $combo';
  }

  @override
  String get builderPrompt => 'Hör zu und bau die Silbe';

  @override
  String get slotInitial => 'Anlaut';

  @override
  String get slotVowel => 'Vokal';

  @override
  String get slotFinal => 'Auslaut';

  @override
  String get wordRushPrompt => 'Lies es und wähle das passende Bild';

  @override
  String get pronMicNeeded => 'Mikrofonzugriff erforderlich';

  @override
  String get pronMicBody =>
      'Das Mikro wird nur zur Bewertung genutzt und\nAufnahmen werden niemals gespeichert.\nBitte erlaube das Mikrofon in den Einstellungen deines Browsers oder Geräts.';

  @override
  String get pronListenThenSay => 'Hör zu, dann sprich nach';

  @override
  String get pronTryAgainNext => 'Nochmal / Weiter';

  @override
  String resultXp(int points) {
    return '+$points XP';
  }

  @override
  String resultBestCombo(int combo) {
    return 'Beste Combo $combo';
  }

  @override
  String resultNewCards(int count, String letters) {
    return 'Neue Codex-Karten: $count · $letters';
  }

  @override
  String get resultToReview => 'Laute zum Wiederholen';

  @override
  String get resultMissedHint =>
      'Buchstaben, die du verpasst, kommen öfter dran';

  @override
  String get resultNextLevel => 'Nächstes Level';

  @override
  String get reviewComplete => 'Wiederholung geschafft!';

  @override
  String reviewScore(int correct, int total) {
    return '$correct / $total richtig';
  }

  @override
  String get reviewTeaserUsed =>
      'Gratis-Wiederholung für heute verbraucht.\nMit Premium wiederholst du unbegrenzt.';

  @override
  String get reviewUnlockUnlimited => 'Unbegrenzte Wiederholung freischalten';

  @override
  String reviewHeader(int n, int total) {
    return 'Smarte Wiederholung  $n/$total';
  }

  @override
  String get reviewQuestion => 'Welcher Buchstabe macht diesen Laut?';

  @override
  String codexTitle(int found, int total) {
    return 'Buchstaben-Codex  $found/$total';
  }

  @override
  String get codexInitials => 'Anlaut-Konsonanten';

  @override
  String get codexVowels => 'Vokale';

  @override
  String get codexFinals => 'Endkonsonanten';

  @override
  String get codexEmptyHint =>
      'Triff in der Jamo-Jagd einen Laut richtig, um deine erste Karte freizuschalten.';

  @override
  String get codexLocked => 'Gesperrt';

  @override
  String get codexMastered => '★ Gemeistert';

  @override
  String get codexVelar =>
      'Geformt wie die Zungenwurzel, die den Rachen blockiert';

  @override
  String get codexAlveolar => 'Geformt wie die Zungenspitze am Zahndamm';

  @override
  String get codexLabial => 'Geformt wie die Lippen';

  @override
  String get codexDental => 'Geformt wie ein Zahn';

  @override
  String get codexGlottal => 'Geformt wie der Rachen';

  @override
  String codexCheonjiin(String parts) {
    return 'Aufgebaut aus Himmel (ㆍ), Erde (ㅡ) und Mensch (ㅣ): $parts';
  }

  @override
  String get codexFinalSound => 'Der Laut, den er als Endkonsonant macht';

  @override
  String get codexHearIt => 'Anhören';

  @override
  String get learnTitle => 'Hangul lernen · 한글 배우기';

  @override
  String get learnIntro =>
      'Alles, was du zum Koreanischlesen brauchst, in 8 kurzen Lektionen.';

  @override
  String learnNext(String title) {
    return 'Weiter: $title';
  }

  @override
  String get learnBackToLessons => 'Zurück zu den Lektionen';

  @override
  String get learnLayoutTall =>
      'senkrechter Vokal: Konsonant links, Vokal rechts';

  @override
  String get learnLayoutFlat =>
      'waagerechter Vokal: Konsonant oben, Vokal darunter';

  @override
  String get learnLayoutMixed =>
      'zusammengesetzter Vokal: legt sich unten und rechts herum';

  @override
  String get learnPickInitial => '1. Erster Konsonant';

  @override
  String get learnPickVowel => '2. Vokal';

  @override
  String get learnPickFinal => '3. Endkonsonant (optional)';

  @override
  String learnExample(String words) {
    return 'z. B. $words';
  }

  @override
  String get talkTitle => 'Koreanisch im Alltag · 상황별 대화';

  @override
  String get talkIntro =>
      'Sätze für Momente, die du wirklich erleben wirst — tippe auf eine Zeile, um sie zu hören.';

  @override
  String get talkRomanization => 'Umschrift';

  @override
  String get talkKeyPhrases => 'Wichtige Sätze';

  @override
  String get talkCultureTip => 'Kultur-Tipp';

  @override
  String get exploreTitle => 'Korea entdecken · 한국 둘러보기';

  @override
  String get exploreTabApps => 'Apps';

  @override
  String get exploreTabHistory => 'Geschichte';

  @override
  String get exploreTabFood => 'Essen';

  @override
  String get exploreTabSaju => 'Saju';

  @override
  String get exploreAppsIntro =>
      'Installier sie vor dem Abflug — damit wird Korea ganz einfach.';

  @override
  String exploreTip(String tip) {
    return 'Tipp: $tip';
  }

  @override
  String get exploreHistoryIntro => '5.000 Jahre in 11 Stationen.';

  @override
  String get exploreFoodIntro =>
      'Gerichte, die du probieren musst. Tippe auf einen Karten-Button, um die bestbewerteten Lokale in deiner Nähe zu sehen — Live-Bewertungen, immer aktuell.';

  @override
  String get exploreNaverEnglish =>
      'Naver Map auf Englisch: Gehe in der App zu MY → Einstellungen → Sprache → English.';

  @override
  String exploreWhere(String place) {
    return 'Wo: $place';
  }

  @override
  String get exploreSajuIntro =>
      'Saju (사주) ist die koreanische Schicksalsdeutung anhand der „vier Säulen“ deiner Geburt: Jahr, Monat, Tag und Stunde. Paare prüfen ihre Kompatibilität — 궁합 — vor großen Entscheidungen.';

  @override
  String get exploreViewOnEtsy => 'Auf Etsy ansehen';

  @override
  String get paywallTitle => 'Lies Hangul von A bis Z';

  @override
  String get paywallPronWeb => 'Aussprachebewertung (Chrome & Safari)';

  @override
  String get paywallReviewWeb =>
      'Unbegrenzte smarte Wiederholung der Laute, die du verpasst';

  @override
  String get paywallStagesWeb => 'Alle Silbenbau-Level plus Wort-Sprint';

  @override
  String get paywallStreakWeb => 'Serien-Reparatur zum Schutz deiner Serie';

  @override
  String get paywallPronApp => 'Aussprachebewertung für jeden Buchstaben';

  @override
  String get paywallReviewApp =>
      'Smarte Wiederholung der Laute, die du verpasst';

  @override
  String get paywallStagesApp =>
      'Alle Stufen, vom Buchstabenbauen bis zum Wörterlesen';

  @override
  String get paywallLoadError => 'Tarife konnten nicht geladen werden';

  @override
  String get paywallNotCompleted => 'Die Zahlung wurde nicht abgeschlossen';

  @override
  String get paywallError =>
      'Zahlungsfehler. Bitte versuche es gleich noch einmal';

  @override
  String get paywallProcessing => 'Wird verarbeitet…';

  @override
  String paywallStartTrial(int days) {
    return '$days Tage gratis testen';
  }

  @override
  String get paywallUnlock => 'Premium freischalten';

  @override
  String get paywallLifetimeTerms =>
      'Einmalzahlung · Kein Abo · Für immer deins';

  @override
  String paywallTrialTerms(String price) {
    return 'Danach $price, verlängert sich automatisch · Jederzeit kündbar';
  }

  @override
  String paywallRenewTerms(String price) {
    return '$price, verlängert sich automatisch · Jederzeit kündbar';
  }

  @override
  String get paywallDemo => 'Demo-Kasse: Dir wird nichts berechnet';

  @override
  String get paywallHowToCancel => 'So kündigst du';

  @override
  String get planLifetime => 'Lebenslang';

  @override
  String get planYearly => 'Jährlich';

  @override
  String get planMonthly => 'Monatlich';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsMusic => 'Musik';

  @override
  String get settingsSfx => 'Soundeffekte';

  @override
  String get settingsVoice => 'Stimme';

  @override
  String get settingsMuteAll => 'Alles stumm';

  @override
  String get settingsPremiumActive => 'Premium aktiv';

  @override
  String get settingsFreePlan => 'Gratis-Tarif';

  @override
  String settingsBilling(String backend) {
    return 'Abrechnung: $backend';
  }

  @override
  String get settingsUnlockAll => 'Schalte mit Premium alle Stufen frei';

  @override
  String get cancelTitle => 'Du kannst jederzeit kündigen';

  @override
  String get cancelBody =>
      '· Abos verlängern sich automatisch, sofern sie nicht mindestens 24 Stunden vor Ende des Zeitraums gekündigt werden.\n\n· iPhone: Einstellungen → Apple ID → Abonnements → Hangul Bricks → Kündigen\n· Web: Nutze den Link in deiner Lemon Squeezy-Quittungs-E-Mail\n\n· Nach der Kündigung bleibt Premium bis zum Ende des bezahlten Zeitraums aktiv.\n\n· Wenn du während des kostenlosen Testzeitraums kündigst, wird dir nichts berechnet.';

  @override
  String get cancelOpenSettings => 'Abo-Einstellungen öffnen';

  @override
  String cancelStoreNote(String channel) {
    return 'Store-Versionen öffnen die Abo-Einstellungen des Betriebssystems (aktueller Kanal: $channel)';
  }

  @override
  String get privacyWeb =>
      '· Dein Fortschritt und deine Fehler werden nur in diesem Browser gespeichert. Kein Konto nötig.\n\n· Für die Aussprachebewertung wird deine Stimme an den Sprachdienst des Browsers (Google in Chrome, Apple in Safari) gesendet und in Text umgewandelt. Sie erreicht niemals die Server von Hangul Bricks, und Aufnahmen werden nicht gespeichert.\n\n· Das Mikrofon wird nur für die Aussprachebewertung genutzt. Wenn du es ablehnst, funktioniert alles andere trotzdem.\n\n· Zahlungen werden von unserem Wiederverkäufer Lemon Squeezy abgewickelt, und die App sieht deine Kartendaten nie.\n\n· Wenn du „Per E-Mail wiederherstellen“ nutzt, wird die eingegebene E-Mail-Adresse an die Server von Hangul Bricks gesendet, um deinen Kauf bei Lemon Squeezy zu finden. Der Einmalcode wird über unseren E-Mail-Dienst Resend zugestellt. Die Adresse wird nicht gespeichert.';

  @override
  String get privacyApp =>
      '· Dein Fortschritt und deine Fehler werden nur auf diesem Gerät gespeichert. Kein Konto nötig.\n\n· Aussprache-Audio wird ausschließlich auf dem Gerät analysiert, und Aufnahmen werden niemals gespeichert oder hochgeladen.\n\n· Das Mikrofon wird nur für die Aussprachebewertung genutzt. Wenn du es ablehnst, funktioniert alles andere trotzdem.\n\n· Zahlungen laufen über In-App-Käufe im App Store, und die App sieht deine Kartendaten nie.';

  @override
  String get termsBody =>
      '· Für die Nutzung von Hangul Bricks gelten die Standard-EULA von Apple und unsere Web-Nutzungsbedingungen.\n\n· Lebenslang: Einmalzahlung — kein Abo, keine Verlängerung.\n\n· Der Monatstarif verlängert sich automatisch zum gleichen Preis, sofern er nicht mindestens 24 Stunden vor Ende des Zeitraums gekündigt wird.\n\n· Wenn du während des kostenlosen Testzeitraums kündigst, wird dir nichts berechnet.';
}
