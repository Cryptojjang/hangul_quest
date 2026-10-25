import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('id'),
    Locale('ja'),
    Locale('pt'),
    Locale('th'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Hangul Bricks'**
  String get appName;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageFollowDevice.
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get languageFollowDevice;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get commonPlay;

  /// No description provided for @commonGo.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get commonGo;

  /// No description provided for @commonBackToMap.
  ///
  /// In en, this message translates to:
  /// **'Back to map'**
  String get commonBackToMap;

  /// No description provided for @commonFree.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get commonFree;

  /// No description provided for @commonRestorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore purchase'**
  String get commonRestorePurchase;

  /// No description provided for @commonPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get commonPrivacyPolicy;

  /// No description provided for @commonTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get commonTermsOfUse;

  /// No description provided for @commonManageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get commonManageSubscription;

  /// No description provided for @commonReadFullText.
  ///
  /// In en, this message translates to:
  /// **'Read the full text'**
  String get commonReadFullText;

  /// No description provided for @commonSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get commonSummary;

  /// No description provided for @commonSubscriptionRestored.
  ///
  /// In en, this message translates to:
  /// **'Subscription restored'**
  String get commonSubscriptionRestored;

  /// No description provided for @commonNoSubscription.
  ///
  /// In en, this message translates to:
  /// **'No subscription to restore'**
  String get commonNoSubscription;

  /// No description provided for @restoreEmailAction.
  ///
  /// In en, this message translates to:
  /// **'Restore with email'**
  String get restoreEmailAction;

  /// No description provided for @restoreEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the email you used at checkout. We\'ll send you a one-time code.'**
  String get restoreEmailBody;

  /// No description provided for @restoreEmailField.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get restoreEmailField;

  /// No description provided for @restoreEmailSend.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get restoreEmailSend;

  /// No description provided for @restoreEmailSent.
  ///
  /// In en, this message translates to:
  /// **'If this email has a purchase, a code is on its way. Check your inbox (and spam folder).'**
  String get restoreEmailSent;

  /// No description provided for @restoreEmailCodeField.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get restoreEmailCodeField;

  /// No description provided for @restoreEmailConfirm.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreEmailConfirm;

  /// No description provided for @restoreEmailBadCode.
  ///
  /// In en, this message translates to:
  /// **'That code is wrong or has expired.'**
  String get restoreEmailBadCode;

  /// No description provided for @restoreEmailError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get restoreEmailError;

  /// No description provided for @commonCouldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Could not open {url}'**
  String commonCouldNotOpen(String url);

  /// No description provided for @onbHookTitle.
  ///
  /// In en, this message translates to:
  /// **'Read the songs you love\nin their own letters'**
  String get onbHookTitle;

  /// No description provided for @onbHookBody.
  ///
  /// In en, this message translates to:
  /// **'Hangul is the world\'s easiest script to learn — its letters snap together like blocks.'**
  String get onbHookBody;

  /// No description provided for @onbPromiseTitle.
  ///
  /// In en, this message translates to:
  /// **'Read Hangul\nin 7 days'**
  String get onbPromiseTitle;

  /// No description provided for @onbPromiseFooter.
  ///
  /// In en, this message translates to:
  /// **'Just play. We handle the rest.'**
  String get onbPromiseFooter;

  /// No description provided for @onbNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'5 minutes a day\nkeeps your streak alive'**
  String get onbNotifTitle;

  /// No description provided for @onbNotifBody.
  ///
  /// In en, this message translates to:
  /// **'Want a gentle evening reminder? It\'s optional.'**
  String get onbNotifBody;

  /// No description provided for @onbAllowReminders.
  ///
  /// In en, this message translates to:
  /// **'Allow reminders'**
  String get onbAllowReminders;

  /// No description provided for @onbGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onbGetStarted;

  /// No description provided for @onbChooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get onbChooseLanguage;

  /// No description provided for @trackerHeader.
  ///
  /// In en, this message translates to:
  /// **'READ HANGUL IN 7 DAYS · DAY {day}'**
  String trackerHeader(int day);

  /// No description provided for @trackerDay1Title.
  ///
  /// In en, this message translates to:
  /// **'Meet the consonants'**
  String get trackerDay1Title;

  /// No description provided for @trackerDay1Goal.
  ///
  /// In en, this message translates to:
  /// **'Recognize 10 basic consonants'**
  String get trackerDay1Goal;

  /// No description provided for @trackerDay2Title.
  ///
  /// In en, this message translates to:
  /// **'How vowels work'**
  String get trackerDay2Title;

  /// No description provided for @trackerDay2Goal.
  ///
  /// In en, this message translates to:
  /// **'6 basic vowels + your first syllable'**
  String get trackerDay2Goal;

  /// No description provided for @trackerDay3Title.
  ///
  /// In en, this message translates to:
  /// **'Building blocks'**
  String get trackerDay3Title;

  /// No description provided for @trackerDay3Goal.
  ///
  /// In en, this message translates to:
  /// **'Stack vertical & horizontal vowels'**
  String get trackerDay3Goal;

  /// No description provided for @trackerDay4Title.
  ///
  /// In en, this message translates to:
  /// **'Final consonants'**
  String get trackerDay4Title;

  /// No description provided for @trackerDay4Goal.
  ///
  /// In en, this message translates to:
  /// **'Syllables with a batchim'**
  String get trackerDay4Goal;

  /// No description provided for @trackerDay5Title.
  ///
  /// In en, this message translates to:
  /// **'Tricky sounds'**
  String get trackerDay5Title;

  /// No description provided for @trackerDay5Goal.
  ///
  /// In en, this message translates to:
  /// **'Tense & aspirated consonants'**
  String get trackerDay5Goal;

  /// No description provided for @trackerDay6Title.
  ///
  /// In en, this message translates to:
  /// **'Reading words'**
  String get trackerDay6Title;

  /// No description provided for @trackerDay6Goal.
  ///
  /// In en, this message translates to:
  /// **'Read your first 12 words'**
  String get trackerDay6Goal;

  /// No description provided for @trackerDay7Title.
  ///
  /// In en, this message translates to:
  /// **'Fluent reader'**
  String get trackerDay7Title;

  /// No description provided for @trackerDay7Goal.
  ///
  /// In en, this message translates to:
  /// **'Sound out any syllable'**
  String get trackerDay7Goal;

  /// No description provided for @homeLearnTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Hangul · 한글 배우기'**
  String get homeLearnTitle;

  /// No description provided for @homeLearnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every letter to reading rules · 8 free lessons'**
  String get homeLearnSubtitle;

  /// No description provided for @homeTalkTitle.
  ///
  /// In en, this message translates to:
  /// **'Real-life Korean · 상황별 대화'**
  String get homeTalkTitle;

  /// No description provided for @homeTalkSubtitlePremium.
  ///
  /// In en, this message translates to:
  /// **'Café, taxi, K-dramas, fan events and more'**
  String get homeTalkSubtitlePremium;

  /// No description provided for @homeTalkSubtitleFree.
  ///
  /// In en, this message translates to:
  /// **'3 free conversations · more with Premium'**
  String get homeTalkSubtitleFree;

  /// No description provided for @homeExploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Korea · 한국 둘러보기'**
  String get homeExploreTitle;

  /// No description provided for @homeExploreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Travel apps, history and food to try'**
  String get homeExploreSubtitle;

  /// No description provided for @homeDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get homeDailyTitle;

  /// No description provided for @homeDailySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your streak with a mixed round'**
  String get homeDailySubtitle;

  /// No description provided for @homeStages.
  ///
  /// In en, this message translates to:
  /// **'Stages'**
  String get homeStages;

  /// No description provided for @homeCodex.
  ///
  /// In en, this message translates to:
  /// **'Letter Codex'**
  String get homeCodex;

  /// No description provided for @homeCodexCount.
  ///
  /// In en, this message translates to:
  /// **'{count} / 67 cards'**
  String homeCodexCount(int count);

  /// No description provided for @homeReview.
  ///
  /// In en, this message translates to:
  /// **'Smart Review'**
  String get homeReview;

  /// No description provided for @homeReviewUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get homeReviewUnlimited;

  /// No description provided for @homeReviewFreeToday.
  ///
  /// In en, this message translates to:
  /// **'Free today {used}/1'**
  String homeReviewFreeToday(int used);

  /// No description provided for @homeLeague.
  ///
  /// In en, this message translates to:
  /// **'Weekly League · Celadon'**
  String get homeLeague;

  /// No description provided for @homeLeagueYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get homeLeagueYou;

  /// No description provided for @homeSpeechUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation is not supported on this device'**
  String get homeSpeechUnsupported;

  /// No description provided for @homeNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Not supported on this device'**
  String get homeNotSupported;

  /// No description provided for @stageJamoHunt.
  ///
  /// In en, this message translates to:
  /// **'Jamo Hunt'**
  String get stageJamoHunt;

  /// No description provided for @stageJamoHuntSub.
  ///
  /// In en, this message translates to:
  /// **'Hear a sound, tap the letter'**
  String get stageJamoHuntSub;

  /// No description provided for @stageLetterBuilder.
  ///
  /// In en, this message translates to:
  /// **'Letter Builder'**
  String get stageLetterBuilder;

  /// No description provided for @stageLetterBuilderSub.
  ///
  /// In en, this message translates to:
  /// **'Snap letters into syllables'**
  String get stageLetterBuilderSub;

  /// No description provided for @stageWordRush.
  ///
  /// In en, this message translates to:
  /// **'Word Rush'**
  String get stageWordRush;

  /// No description provided for @stageWordRushSub.
  ///
  /// In en, this message translates to:
  /// **'Read words, match pictures'**
  String get stageWordRushSub;

  /// No description provided for @stagePronunciation.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation'**
  String get stagePronunciation;

  /// No description provided for @stagePronunciationSub.
  ///
  /// In en, this message translates to:
  /// **'Get your pronunciation scored'**
  String get stagePronunciationSub;

  /// No description provided for @miniJamoTitle.
  ///
  /// In en, this message translates to:
  /// **'Letters that draw sounds'**
  String get miniJamoTitle;

  /// No description provided for @miniJamoBody.
  ///
  /// In en, this message translates to:
  /// **'ㄱ shows the tongue blocking the throat, ㅁ shows the lips.\nKorean consonants are pictures of your mouth.'**
  String get miniJamoBody;

  /// No description provided for @miniJamoPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap to hear the sound'**
  String get miniJamoPrompt;

  /// No description provided for @miniBuilderTitle.
  ///
  /// In en, this message translates to:
  /// **'Why does Hangul stack like blocks?'**
  String get miniBuilderTitle;

  /// No description provided for @miniBuilderBody.
  ///
  /// In en, this message translates to:
  /// **'Initial, vowel and final letters stack into one block.\nThe shape of the vowel decides the layout.'**
  String get miniBuilderBody;

  /// No description provided for @miniBuilderPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap to build the syllable'**
  String get miniBuilderPrompt;

  /// No description provided for @miniWordTitle.
  ///
  /// In en, this message translates to:
  /// **'Now read real words'**
  String get miniWordTitle;

  /// No description provided for @miniWordBody.
  ///
  /// In en, this message translates to:
  /// **'If you can build it, you can read it.\nRead fast and pick the matching picture.'**
  String get miniWordBody;

  /// No description provided for @miniWordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap to make the word'**
  String get miniWordPrompt;

  /// No description provided for @miniSpeakTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to say it out loud?'**
  String get miniSpeakTitle;

  /// No description provided for @miniSpeakBody.
  ///
  /// In en, this message translates to:
  /// **'Last comes speaking. Say it into the mic and\nwe score which sounds you nailed.'**
  String get miniSpeakBody;

  /// No description provided for @miniSpeakPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap to listen first'**
  String get miniSpeakPrompt;

  /// No description provided for @miniSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip →'**
  String get miniSkip;

  /// No description provided for @miniStartsIn.
  ///
  /// In en, this message translates to:
  /// **'Starts in {seconds}s'**
  String miniStartsIn(int seconds);

  /// No description provided for @miniTapToReplay.
  ///
  /// In en, this message translates to:
  /// **'Tap to replay'**
  String get miniTapToReplay;

  /// No description provided for @jamoHuntPrompt.
  ///
  /// In en, this message translates to:
  /// **'Find the letter for this sound'**
  String get jamoHuntPrompt;

  /// No description provided for @comboActive.
  ///
  /// In en, this message translates to:
  /// **'x{multiplier} Combo {combo}'**
  String comboActive(int multiplier, int combo);

  /// No description provided for @comboIdle.
  ///
  /// In en, this message translates to:
  /// **'Combo {combo}'**
  String comboIdle(int combo);

  /// No description provided for @builderPrompt.
  ///
  /// In en, this message translates to:
  /// **'Listen and build the syllable'**
  String get builderPrompt;

  /// No description provided for @slotInitial.
  ///
  /// In en, this message translates to:
  /// **'Initial'**
  String get slotInitial;

  /// No description provided for @slotVowel.
  ///
  /// In en, this message translates to:
  /// **'Vowel'**
  String get slotVowel;

  /// No description provided for @slotFinal.
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get slotFinal;

  /// No description provided for @wordRushPrompt.
  ///
  /// In en, this message translates to:
  /// **'Read it, then pick the matching picture'**
  String get wordRushPrompt;

  /// No description provided for @pronMicNeeded.
  ///
  /// In en, this message translates to:
  /// **'Microphone access needed'**
  String get pronMicNeeded;

  /// No description provided for @pronMicBody.
  ///
  /// In en, this message translates to:
  /// **'The mic is used only for scoring and\nrecordings are never stored.\nPlease allow the microphone in your browser or device settings.'**
  String get pronMicBody;

  /// No description provided for @pronListenThenSay.
  ///
  /// In en, this message translates to:
  /// **'Listen, then say it'**
  String get pronListenThenSay;

  /// No description provided for @pronTryAgainNext.
  ///
  /// In en, this message translates to:
  /// **'Try again / Next'**
  String get pronTryAgainNext;

  /// No description provided for @resultXp.
  ///
  /// In en, this message translates to:
  /// **'+{points} XP'**
  String resultXp(int points);

  /// No description provided for @resultBestCombo.
  ///
  /// In en, this message translates to:
  /// **'Best combo {combo}'**
  String resultBestCombo(int combo);

  /// No description provided for @resultNewCards.
  ///
  /// In en, this message translates to:
  /// **'New codex cards: {count} · {letters}'**
  String resultNewCards(int count, String letters);

  /// No description provided for @resultToReview.
  ///
  /// In en, this message translates to:
  /// **'Sounds to review'**
  String get resultToReview;

  /// No description provided for @resultMissedHint.
  ///
  /// In en, this message translates to:
  /// **'Letters you miss will show up more often'**
  String get resultMissedHint;

  /// No description provided for @resultNextLevel.
  ///
  /// In en, this message translates to:
  /// **'Next level'**
  String get resultNextLevel;

  /// No description provided for @reviewComplete.
  ///
  /// In en, this message translates to:
  /// **'Review complete!'**
  String get reviewComplete;

  /// No description provided for @reviewScore.
  ///
  /// In en, this message translates to:
  /// **'{correct} / {total} correct'**
  String reviewScore(int correct, int total);

  /// No description provided for @reviewTeaserUsed.
  ///
  /// In en, this message translates to:
  /// **'Free review used for today.\nPremium unlocks unlimited reviews.'**
  String get reviewTeaserUsed;

  /// No description provided for @reviewUnlockUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited review'**
  String get reviewUnlockUnlimited;

  /// No description provided for @reviewHeader.
  ///
  /// In en, this message translates to:
  /// **'Smart Review  {n}/{total}'**
  String reviewHeader(int n, int total);

  /// No description provided for @reviewQuestion.
  ///
  /// In en, this message translates to:
  /// **'Which letter makes this sound?'**
  String get reviewQuestion;

  /// No description provided for @codexTitle.
  ///
  /// In en, this message translates to:
  /// **'Letter Codex  {found}/{total}'**
  String codexTitle(int found, int total);

  /// No description provided for @codexInitials.
  ///
  /// In en, this message translates to:
  /// **'Initial consonants'**
  String get codexInitials;

  /// No description provided for @codexVowels.
  ///
  /// In en, this message translates to:
  /// **'Vowels'**
  String get codexVowels;

  /// No description provided for @codexFinals.
  ///
  /// In en, this message translates to:
  /// **'Final consonants'**
  String get codexFinals;

  /// No description provided for @codexEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Get a sound right in Jamo Hunt to unlock your first card.'**
  String get codexEmptyHint;

  /// No description provided for @codexLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get codexLocked;

  /// No description provided for @codexMastered.
  ///
  /// In en, this message translates to:
  /// **'★ Mastered'**
  String get codexMastered;

  /// No description provided for @codexVelar.
  ///
  /// In en, this message translates to:
  /// **'Shaped like the tongue root blocking the throat'**
  String get codexVelar;

  /// No description provided for @codexAlveolar.
  ///
  /// In en, this message translates to:
  /// **'Shaped like the tongue tip touching the gum ridge'**
  String get codexAlveolar;

  /// No description provided for @codexLabial.
  ///
  /// In en, this message translates to:
  /// **'Shaped like the lips'**
  String get codexLabial;

  /// No description provided for @codexDental.
  ///
  /// In en, this message translates to:
  /// **'Shaped like a tooth'**
  String get codexDental;

  /// No description provided for @codexGlottal.
  ///
  /// In en, this message translates to:
  /// **'Shaped like the throat'**
  String get codexGlottal;

  /// No description provided for @codexCheonjiin.
  ///
  /// In en, this message translates to:
  /// **'Built from sky (ㆍ), earth (ㅡ) and person (ㅣ): {parts}'**
  String codexCheonjiin(String parts);

  /// No description provided for @codexFinalSound.
  ///
  /// In en, this message translates to:
  /// **'The sound it makes as a final consonant'**
  String get codexFinalSound;

  /// No description provided for @codexHearIt.
  ///
  /// In en, this message translates to:
  /// **'Hear it'**
  String get codexHearIt;

  /// No description provided for @learnTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Hangul · 한글 배우기'**
  String get learnTitle;

  /// No description provided for @learnIntro.
  ///
  /// In en, this message translates to:
  /// **'Everything you need to read Korean, in 8 short lessons.'**
  String get learnIntro;

  /// No description provided for @learnNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {title}'**
  String learnNext(String title);

  /// No description provided for @learnBackToLessons.
  ///
  /// In en, this message translates to:
  /// **'Back to lessons'**
  String get learnBackToLessons;

  /// No description provided for @learnLayoutTall.
  ///
  /// In en, this message translates to:
  /// **'tall vowel: consonant left, vowel right'**
  String get learnLayoutTall;

  /// No description provided for @learnLayoutFlat.
  ///
  /// In en, this message translates to:
  /// **'flat vowel: consonant top, vowel below'**
  String get learnLayoutFlat;

  /// No description provided for @learnLayoutMixed.
  ///
  /// In en, this message translates to:
  /// **'combined vowel: wraps below and right'**
  String get learnLayoutMixed;

  /// No description provided for @learnPickInitial.
  ///
  /// In en, this message translates to:
  /// **'1. First consonant'**
  String get learnPickInitial;

  /// No description provided for @learnPickVowel.
  ///
  /// In en, this message translates to:
  /// **'2. Vowel'**
  String get learnPickVowel;

  /// No description provided for @learnPickFinal.
  ///
  /// In en, this message translates to:
  /// **'3. Final consonant (optional)'**
  String get learnPickFinal;

  /// No description provided for @learnExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. {words}'**
  String learnExample(String words);

  /// No description provided for @talkTitle.
  ///
  /// In en, this message translates to:
  /// **'Real-life Korean · 상황별 대화'**
  String get talkTitle;

  /// No description provided for @talkIntro.
  ///
  /// In en, this message translates to:
  /// **'Phrases for the moments you will actually be in — tap any line to hear it.'**
  String get talkIntro;

  /// No description provided for @talkRomanization.
  ///
  /// In en, this message translates to:
  /// **'Romanization'**
  String get talkRomanization;

  /// No description provided for @talkKeyPhrases.
  ///
  /// In en, this message translates to:
  /// **'Key phrases'**
  String get talkKeyPhrases;

  /// No description provided for @talkCultureTip.
  ///
  /// In en, this message translates to:
  /// **'Culture tip'**
  String get talkCultureTip;

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Korea · 한국 둘러보기'**
  String get exploreTitle;

  /// No description provided for @exploreTabApps.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get exploreTabApps;

  /// No description provided for @exploreTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get exploreTabHistory;

  /// No description provided for @exploreTabFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get exploreTabFood;

  /// No description provided for @exploreTabSaju.
  ///
  /// In en, this message translates to:
  /// **'Saju'**
  String get exploreTabSaju;

  /// No description provided for @exploreAppsIntro.
  ///
  /// In en, this message translates to:
  /// **'Install these before you fly — they make Korea easy.'**
  String get exploreAppsIntro;

  /// No description provided for @exploreTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: {tip}'**
  String exploreTip(String tip);

  /// No description provided for @exploreHistoryIntro.
  ///
  /// In en, this message translates to:
  /// **'5,000 years in 11 stops.'**
  String get exploreHistoryIntro;

  /// No description provided for @exploreFoodIntro.
  ///
  /// In en, this message translates to:
  /// **'Must-try dishes. Tap a map button to see top-rated places near you right now — live ratings, never out of date.'**
  String get exploreFoodIntro;

  /// No description provided for @exploreNaverEnglish.
  ///
  /// In en, this message translates to:
  /// **'Naver Map in English: in the app go to MY → Settings → Language → English.'**
  String get exploreNaverEnglish;

  /// No description provided for @exploreWhere.
  ///
  /// In en, this message translates to:
  /// **'Where: {place}'**
  String exploreWhere(String place);

  /// No description provided for @exploreSajuIntro.
  ///
  /// In en, this message translates to:
  /// **'Saju (사주) is Korean fortune reading from the \"four pillars\" of your birth year, month, day and hour. Couples check their compatibility — 궁합 — before big decisions.'**
  String get exploreSajuIntro;

  /// No description provided for @exploreViewOnEtsy.
  ///
  /// In en, this message translates to:
  /// **'View on Etsy'**
  String get exploreViewOnEtsy;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Read Hangul all the way'**
  String get paywallTitle;

  /// No description provided for @paywallPronWeb.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation scoring (Chrome & Safari)'**
  String get paywallPronWeb;

  /// No description provided for @paywallReviewWeb.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Smart Review of the sounds you miss'**
  String get paywallReviewWeb;

  /// No description provided for @paywallStagesWeb.
  ///
  /// In en, this message translates to:
  /// **'Every Letter Builder level plus Word Rush'**
  String get paywallStagesWeb;

  /// No description provided for @paywallStreakWeb.
  ///
  /// In en, this message translates to:
  /// **'Streak repair to protect your streak'**
  String get paywallStreakWeb;

  /// No description provided for @paywallPronApp.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation scoring for every letter'**
  String get paywallPronApp;

  /// No description provided for @paywallReviewApp.
  ///
  /// In en, this message translates to:
  /// **'Smart Review of the sounds you miss'**
  String get paywallReviewApp;

  /// No description provided for @paywallStagesApp.
  ///
  /// In en, this message translates to:
  /// **'Every stage, from building letters to reading words'**
  String get paywallStagesApp;

  /// No description provided for @paywallLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load plans'**
  String get paywallLoadError;

  /// No description provided for @paywallNotCompleted.
  ///
  /// In en, this message translates to:
  /// **'Payment was not completed'**
  String get paywallNotCompleted;

  /// No description provided for @paywallError.
  ///
  /// In en, this message translates to:
  /// **'Payment error. Please try again shortly'**
  String get paywallError;

  /// No description provided for @paywallProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing…'**
  String get paywallProcessing;

  /// No description provided for @paywallStartTrial.
  ///
  /// In en, this message translates to:
  /// **'Start {days}-day free trial'**
  String paywallStartTrial(int days);

  /// No description provided for @paywallUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get paywallUnlock;

  /// No description provided for @paywallLifetimeTerms.
  ///
  /// In en, this message translates to:
  /// **'One-time payment · No subscription · Yours forever'**
  String get paywallLifetimeTerms;

  /// No description provided for @paywallTrialTerms.
  ///
  /// In en, this message translates to:
  /// **'Then {price}, auto-renews · Cancel anytime'**
  String paywallTrialTerms(String price);

  /// No description provided for @paywallRenewTerms.
  ///
  /// In en, this message translates to:
  /// **'{price}, auto-renews · Cancel anytime'**
  String paywallRenewTerms(String price);

  /// No description provided for @paywallDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo checkout: you will not be charged'**
  String get paywallDemo;

  /// No description provided for @paywallHowToCancel.
  ///
  /// In en, this message translates to:
  /// **'How to cancel'**
  String get paywallHowToCancel;

  /// No description provided for @planLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get planLifetime;

  /// No description provided for @planYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get planYearly;

  /// No description provided for @planMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get planMonthly;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get settingsMusic;

  /// No description provided for @settingsSfx.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get settingsSfx;

  /// No description provided for @settingsVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get settingsVoice;

  /// No description provided for @settingsMuteAll.
  ///
  /// In en, this message translates to:
  /// **'Mute all'**
  String get settingsMuteAll;

  /// No description provided for @settingsPremiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium active'**
  String get settingsPremiumActive;

  /// No description provided for @settingsFreePlan.
  ///
  /// In en, this message translates to:
  /// **'Free plan'**
  String get settingsFreePlan;

  /// No description provided for @settingsBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing: {backend}'**
  String settingsBilling(String backend);

  /// No description provided for @settingsUnlockAll.
  ///
  /// In en, this message translates to:
  /// **'Unlock every stage with Premium'**
  String get settingsUnlockAll;

  /// No description provided for @cancelTitle.
  ///
  /// In en, this message translates to:
  /// **'You can cancel anytime'**
  String get cancelTitle;

  /// No description provided for @cancelBody.
  ///
  /// In en, this message translates to:
  /// **'· Subscriptions renew automatically unless cancelled at least 24 hours before the period ends.\n\n· iPhone: Settings → Apple ID → Subscriptions → Hangul Bricks → Cancel\n· Web: use the link in your Lemon Squeezy receipt email\n\n· After cancelling, Premium stays active until the paid period ends.\n\n· Cancel during the free trial and you will not be charged.'**
  String get cancelBody;

  /// No description provided for @cancelOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open subscription settings'**
  String get cancelOpenSettings;

  /// No description provided for @cancelStoreNote.
  ///
  /// In en, this message translates to:
  /// **'Store builds open the OS subscription settings (current channel: {channel})'**
  String cancelStoreNote(String channel);

  /// No description provided for @privacyWeb.
  ///
  /// In en, this message translates to:
  /// **'· Your progress and mistakes are saved only in this browser. No account needed.\n\n· For pronunciation scoring, your voice is sent to the browser\'s speech service (Google in Chrome, Apple in Safari) to be turned into text. It never reaches Hangul Bricks servers and recordings are not stored.\n\n· The microphone is used only for pronunciation scoring. If you deny it, everything else still works.\n\n· Payments are handled by our reseller Lemon Squeezy, and the app never sees your card details.'**
  String get privacyWeb;

  /// No description provided for @privacyApp.
  ///
  /// In en, this message translates to:
  /// **'· Your progress and mistakes are saved only on this device. No account needed.\n\n· Pronunciation audio is analyzed on-device only, and recordings are never stored or uploaded.\n\n· The microphone is used only for pronunciation scoring. If you deny it, everything else still works.\n\n· Payments go through App Store in-app purchase, and the app never sees your card details.'**
  String get privacyApp;

  /// No description provided for @termsBody.
  ///
  /// In en, this message translates to:
  /// **'· Use of Hangul Bricks is covered by the Apple standard EULA and our web Terms of Service.\n\n· Lifetime: One-time payment — no subscription, no renewal.\n\n· The monthly plan renews automatically at the same price unless cancelled at least 24 hours before the period ends.\n\n· Cancel during the free trial and you will not be charged.'**
  String get termsBody;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'id',
        'ja',
        'pt',
        'th',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return L10nZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return L10nDe();
    case 'en':
      return L10nEn();
    case 'es':
      return L10nEs();
    case 'fr':
      return L10nFr();
    case 'id':
      return L10nId();
    case 'ja':
      return L10nJa();
    case 'pt':
      return L10nPt();
    case 'th':
      return L10nTh();
    case 'vi':
      return L10nVi();
    case 'zh':
      return L10nZh();
  }

  throw FlutterError(
      'L10n.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
