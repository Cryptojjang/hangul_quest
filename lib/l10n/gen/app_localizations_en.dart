// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Hangul Bricks';

  @override
  String get language => 'Language';

  @override
  String get languageFollowDevice => 'Device language';

  @override
  String get commonNext => 'Next';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonPlay => 'Play';

  @override
  String get commonGo => 'Go';

  @override
  String get commonBackToMap => 'Back to map';

  @override
  String get commonFree => 'FREE';

  @override
  String get commonRestorePurchase => 'Restore purchase';

  @override
  String get commonPrivacyPolicy => 'Privacy Policy';

  @override
  String get commonTermsOfUse => 'Terms of Use';

  @override
  String get commonManageSubscription => 'Manage subscription';

  @override
  String get commonReadFullText => 'Read the full text';

  @override
  String get commonSummary => 'Summary';

  @override
  String get commonSubscriptionRestored => 'Subscription restored';

  @override
  String get commonNoSubscription => 'No subscription to restore';

  @override
  String get restoreEmailAction => 'Restore with email';

  @override
  String get restoreEmailBody =>
      'Enter the email you used at checkout. We\'ll send you a one-time code.';

  @override
  String get restoreEmailField => 'Email';

  @override
  String get restoreEmailSend => 'Send code';

  @override
  String get restoreEmailSent =>
      'If this email has a purchase, a code is on its way. Check your inbox (and spam folder).';

  @override
  String get restoreEmailCodeField => 'Code';

  @override
  String get restoreEmailConfirm => 'Restore';

  @override
  String get restoreEmailBadCode => 'That code is wrong or has expired.';

  @override
  String get restoreEmailError => 'Something went wrong. Please try again.';

  @override
  String commonCouldNotOpen(String url) {
    return 'Could not open $url';
  }

  @override
  String get onbHookTitle => 'Read the songs you love\nin their own letters';

  @override
  String get onbHookBody =>
      'Hangul is the world\'s easiest script to learn — its letters snap together like blocks.';

  @override
  String get onbPromiseTitle => 'Read Hangul\nin 7 days';

  @override
  String get onbPromiseFooter => 'Just play. We handle the rest.';

  @override
  String get onbNotifTitle => '5 minutes a day\nkeeps your streak alive';

  @override
  String get onbNotifBody => 'Want a gentle evening reminder? It\'s optional.';

  @override
  String get onbAllowReminders => 'Allow reminders';

  @override
  String get onbGetStarted => 'Get started';

  @override
  String get onbChooseLanguage => 'Choose your language';

  @override
  String trackerHeader(int day) {
    return 'READ HANGUL IN 7 DAYS · DAY $day';
  }

  @override
  String get trackerDay1Title => 'Meet the consonants';

  @override
  String get trackerDay1Goal => 'Recognize 10 basic consonants';

  @override
  String get trackerDay2Title => 'How vowels work';

  @override
  String get trackerDay2Goal => '6 basic vowels + your first syllable';

  @override
  String get trackerDay3Title => 'Building blocks';

  @override
  String get trackerDay3Goal => 'Stack vertical & horizontal vowels';

  @override
  String get trackerDay4Title => 'Final consonants';

  @override
  String get trackerDay4Goal => 'Syllables with a batchim';

  @override
  String get trackerDay5Title => 'Tricky sounds';

  @override
  String get trackerDay5Goal => 'Tense & aspirated consonants';

  @override
  String get trackerDay6Title => 'Reading words';

  @override
  String get trackerDay6Goal => 'Read your first 12 words';

  @override
  String get trackerDay7Title => 'Fluent reader';

  @override
  String get trackerDay7Goal => 'Sound out any syllable';

  @override
  String get homeLearnTitle => 'Learn Hangul · 한글 배우기';

  @override
  String get homeLearnSubtitle =>
      'Every letter to reading rules · 8 free lessons';

  @override
  String get homeTalkTitle => 'Real-life Korean · 상황별 대화';

  @override
  String get homeTalkSubtitlePremium =>
      'Café, taxi, K-dramas, fan events and more';

  @override
  String get homeTalkSubtitleFree => '3 free conversations · more with Premium';

  @override
  String get homeExploreTitle => 'Explore Korea · 한국 둘러보기';

  @override
  String get homeExploreSubtitle => 'Travel apps, history and food to try';

  @override
  String get homeDailyTitle => 'Daily Challenge';

  @override
  String get homeDailySubtitle => 'Keep your streak with a mixed round';

  @override
  String get homeStages => 'Stages';

  @override
  String get homeCodex => 'Letter Codex';

  @override
  String homeCodexCount(int count) {
    return '$count / 67 cards';
  }

  @override
  String get homeReview => 'Smart Review';

  @override
  String get homeReviewUnlimited => 'Unlimited';

  @override
  String homeReviewFreeToday(int used) {
    return 'Free today $used/1';
  }

  @override
  String get homeLeague => 'Weekly League · Celadon';

  @override
  String get homeLeagueYou => 'You';

  @override
  String get homeSpeechUnsupported =>
      'Pronunciation is not supported on this device';

  @override
  String get homeNotSupported => 'Not supported on this device';

  @override
  String get stageJamoHunt => 'Jamo Hunt';

  @override
  String get stageJamoHuntSub => 'Hear a sound, tap the letter';

  @override
  String get stageLetterBuilder => 'Letter Builder';

  @override
  String get stageLetterBuilderSub => 'Snap letters into syllables';

  @override
  String get stageWordRush => 'Word Rush';

  @override
  String get stageWordRushSub => 'Read words, match pictures';

  @override
  String get stagePronunciation => 'Pronunciation';

  @override
  String get stagePronunciationSub => 'Get your pronunciation scored';

  @override
  String get miniJamoTitle => 'Letters that draw sounds';

  @override
  String get miniJamoBody =>
      'ㄱ shows the tongue blocking the throat, ㅁ shows the lips.\nKorean consonants are pictures of your mouth.';

  @override
  String get miniJamoPrompt => 'Tap to hear the sound';

  @override
  String get miniBuilderTitle => 'Why does Hangul stack like blocks?';

  @override
  String get miniBuilderBody =>
      'Initial, vowel and final letters stack into one block.\nThe shape of the vowel decides the layout.';

  @override
  String get miniBuilderPrompt => 'Tap to build the syllable';

  @override
  String get miniWordTitle => 'Now read real words';

  @override
  String get miniWordBody =>
      'If you can build it, you can read it.\nRead fast and pick the matching picture.';

  @override
  String get miniWordPrompt => 'Tap to make the word';

  @override
  String get miniSpeakTitle => 'Ready to say it out loud?';

  @override
  String get miniSpeakBody =>
      'Last comes speaking. Say it into the mic and\nwe score which sounds you nailed.';

  @override
  String get miniSpeakPrompt => 'Tap to listen first';

  @override
  String get miniSkip => 'Skip →';

  @override
  String miniStartsIn(int seconds) {
    return 'Starts in ${seconds}s';
  }

  @override
  String get miniTapToReplay => 'Tap to replay';

  @override
  String get jamoHuntPrompt => 'Find the letter for this sound';

  @override
  String comboActive(int multiplier, int combo) {
    return 'x$multiplier Combo $combo';
  }

  @override
  String comboIdle(int combo) {
    return 'Combo $combo';
  }

  @override
  String get builderPrompt => 'Listen and build the syllable';

  @override
  String get slotInitial => 'Initial';

  @override
  String get slotVowel => 'Vowel';

  @override
  String get slotFinal => 'Final';

  @override
  String get wordRushPrompt => 'Read it, then pick the matching picture';

  @override
  String get pronMicNeeded => 'Microphone access needed';

  @override
  String get pronMicBody =>
      'The mic is used only for scoring and\nrecordings are never stored.\nPlease allow the microphone in your browser or device settings.';

  @override
  String get pronListenThenSay => 'Listen, then say it';

  @override
  String get pronTryAgainNext => 'Try again / Next';

  @override
  String resultXp(int points) {
    return '+$points XP';
  }

  @override
  String resultBestCombo(int combo) {
    return 'Best combo $combo';
  }

  @override
  String resultNewCards(int count, String letters) {
    return 'New codex cards: $count · $letters';
  }

  @override
  String get resultToReview => 'Sounds to review';

  @override
  String get resultMissedHint => 'Letters you miss will show up more often';

  @override
  String get resultNextLevel => 'Next level';

  @override
  String get reviewComplete => 'Review complete!';

  @override
  String reviewScore(int correct, int total) {
    return '$correct / $total correct';
  }

  @override
  String get reviewTeaserUsed =>
      'Free review used for today.\nPremium unlocks unlimited reviews.';

  @override
  String get reviewUnlockUnlimited => 'Unlock unlimited review';

  @override
  String reviewHeader(int n, int total) {
    return 'Smart Review  $n/$total';
  }

  @override
  String get reviewQuestion => 'Which letter makes this sound?';

  @override
  String codexTitle(int found, int total) {
    return 'Letter Codex  $found/$total';
  }

  @override
  String get codexInitials => 'Initial consonants';

  @override
  String get codexVowels => 'Vowels';

  @override
  String get codexFinals => 'Final consonants';

  @override
  String get codexEmptyHint =>
      'Get a sound right in Jamo Hunt to unlock your first card.';

  @override
  String get codexLocked => 'Locked';

  @override
  String get codexMastered => '★ Mastered';

  @override
  String get codexVelar => 'Shaped like the tongue root blocking the throat';

  @override
  String get codexAlveolar =>
      'Shaped like the tongue tip touching the gum ridge';

  @override
  String get codexLabial => 'Shaped like the lips';

  @override
  String get codexDental => 'Shaped like a tooth';

  @override
  String get codexGlottal => 'Shaped like the throat';

  @override
  String codexCheonjiin(String parts) {
    return 'Built from sky (ㆍ), earth (ㅡ) and person (ㅣ): $parts';
  }

  @override
  String get codexFinalSound => 'The sound it makes as a final consonant';

  @override
  String get codexHearIt => 'Hear it';

  @override
  String get learnTitle => 'Learn Hangul · 한글 배우기';

  @override
  String get learnIntro =>
      'Everything you need to read Korean, in 8 short lessons.';

  @override
  String learnNext(String title) {
    return 'Next: $title';
  }

  @override
  String get learnBackToLessons => 'Back to lessons';

  @override
  String get learnLayoutTall => 'tall vowel: consonant left, vowel right';

  @override
  String get learnLayoutFlat => 'flat vowel: consonant top, vowel below';

  @override
  String get learnLayoutMixed => 'combined vowel: wraps below and right';

  @override
  String get learnPickInitial => '1. First consonant';

  @override
  String get learnPickVowel => '2. Vowel';

  @override
  String get learnPickFinal => '3. Final consonant (optional)';

  @override
  String learnExample(String words) {
    return 'e.g. $words';
  }

  @override
  String get talkTitle => 'Real-life Korean · 상황별 대화';

  @override
  String get talkIntro =>
      'Phrases for the moments you will actually be in — tap any line to hear it.';

  @override
  String get talkRomanization => 'Romanization';

  @override
  String get talkKeyPhrases => 'Key phrases';

  @override
  String get talkCultureTip => 'Culture tip';

  @override
  String get exploreTitle => 'Explore Korea · 한국 둘러보기';

  @override
  String get exploreTabApps => 'Apps';

  @override
  String get exploreTabHistory => 'History';

  @override
  String get exploreTabFood => 'Food';

  @override
  String get exploreTabSaju => 'Saju';

  @override
  String get exploreAppsIntro =>
      'Install these before you fly — they make Korea easy.';

  @override
  String exploreTip(String tip) {
    return 'Tip: $tip';
  }

  @override
  String get exploreHistoryIntro => '5,000 years in 11 stops.';

  @override
  String get exploreFoodIntro =>
      'Must-try dishes. Tap a map button to see top-rated places near you right now — live ratings, never out of date.';

  @override
  String get exploreNaverEnglish =>
      'Naver Map in English: in the app go to MY → Settings → Language → English.';

  @override
  String exploreWhere(String place) {
    return 'Where: $place';
  }

  @override
  String get exploreSajuIntro =>
      'Saju (사주) is Korean fortune reading from the \"four pillars\" of your birth year, month, day and hour. Couples check their compatibility — 궁합 — before big decisions.';

  @override
  String get exploreViewOnEtsy => 'View on Etsy';

  @override
  String get paywallTitle => 'Read Hangul all the way';

  @override
  String get paywallPronWeb => 'Pronunciation scoring (Chrome & Safari)';

  @override
  String get paywallReviewWeb =>
      'Unlimited Smart Review of the sounds you miss';

  @override
  String get paywallStagesWeb => 'Every Letter Builder level plus Word Rush';

  @override
  String get paywallStreakWeb => 'Streak repair to protect your streak';

  @override
  String get paywallPronApp => 'Pronunciation scoring for every letter';

  @override
  String get paywallReviewApp => 'Smart Review of the sounds you miss';

  @override
  String get paywallStagesApp =>
      'Every stage, from building letters to reading words';

  @override
  String get paywallLoadError => 'Could not load plans';

  @override
  String get paywallNotCompleted => 'Payment was not completed';

  @override
  String get paywallError => 'Payment error. Please try again shortly';

  @override
  String get paywallProcessing => 'Processing…';

  @override
  String paywallStartTrial(int days) {
    return 'Start $days-day free trial';
  }

  @override
  String get paywallUnlock => 'Unlock Premium';

  @override
  String get paywallLifetimeTerms =>
      'One-time payment · No subscription · Yours forever';

  @override
  String paywallTrialTerms(String price) {
    return 'Then $price, auto-renews · Cancel anytime';
  }

  @override
  String paywallRenewTerms(String price) {
    return '$price, auto-renews · Cancel anytime';
  }

  @override
  String get paywallDemo => 'Demo checkout: you will not be charged';

  @override
  String get paywallHowToCancel => 'How to cancel';

  @override
  String get planLifetime => 'Lifetime';

  @override
  String get planYearly => 'Yearly';

  @override
  String get planMonthly => 'Monthly';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsMusic => 'Music';

  @override
  String get settingsSfx => 'Sound effects';

  @override
  String get settingsVoice => 'Voice';

  @override
  String get settingsMuteAll => 'Mute all';

  @override
  String get settingsPremiumActive => 'Premium active';

  @override
  String get settingsFreePlan => 'Free plan';

  @override
  String settingsBilling(String backend) {
    return 'Billing: $backend';
  }

  @override
  String get settingsUnlockAll => 'Unlock every stage with Premium';

  @override
  String get cancelTitle => 'You can cancel anytime';

  @override
  String get cancelBody =>
      '· Subscriptions renew automatically unless cancelled at least 24 hours before the period ends.\n\n· iPhone: Settings → Apple ID → Subscriptions → Hangul Bricks → Cancel\n· Web: use the link in your Lemon Squeezy receipt email\n\n· After cancelling, Premium stays active until the paid period ends.\n\n· Cancel during the free trial and you will not be charged.';

  @override
  String get cancelOpenSettings => 'Open subscription settings';

  @override
  String cancelStoreNote(String channel) {
    return 'Store builds open the OS subscription settings (current channel: $channel)';
  }

  @override
  String get privacyWeb =>
      '· Your progress and mistakes are saved only in this browser. No account needed.\n\n· For pronunciation scoring, your voice is sent to the browser\'s speech service (Google in Chrome, Apple in Safari) to be turned into text. It never reaches Hangul Bricks servers and recordings are not stored.\n\n· The microphone is used only for pronunciation scoring. If you deny it, everything else still works.\n\n· Payments are handled by our reseller Lemon Squeezy, and the app never sees your card details.';

  @override
  String get privacyApp =>
      '· Your progress and mistakes are saved only on this device. No account needed.\n\n· Pronunciation audio is analyzed on-device only, and recordings are never stored or uploaded.\n\n· The microphone is used only for pronunciation scoring. If you deny it, everything else still works.\n\n· Payments go through App Store in-app purchase, and the app never sees your card details.';

  @override
  String get termsBody =>
      '· Use of Hangul Bricks is covered by the Apple standard EULA and our web Terms of Service.\n\n· Lifetime: One-time payment — no subscription, no renewal.\n\n· The monthly plan renews automatically at the same price unless cancelled at least 24 hours before the period ends.\n\n· Cancel during the free trial and you will not be charged.';
}
