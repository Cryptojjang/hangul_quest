// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class L10nFr extends L10n {
  L10nFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Hangul Bricks';

  @override
  String get language => 'Langue';

  @override
  String get languageFollowDevice => 'Langue de l\'appareil';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonSkip => 'Passer';

  @override
  String get commonPlay => 'Jouer';

  @override
  String get commonGo => 'Go';

  @override
  String get commonBackToMap => 'Retour à la carte';

  @override
  String get commonFree => 'GRATUIT';

  @override
  String get commonRestorePurchase => 'Restaurer l\'achat';

  @override
  String get commonPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get commonTermsOfUse => 'Conditions d\'utilisation';

  @override
  String get commonManageSubscription => 'Gérer l\'abonnement';

  @override
  String get commonReadFullText => 'Lire le texte complet';

  @override
  String get commonSummary => 'Résumé';

  @override
  String get commonSubscriptionRestored => 'Abonnement restauré';

  @override
  String get commonNoSubscription => 'Aucun abonnement à restaurer';

  @override
  String get restoreEmailAction => 'Restaurer par e-mail';

  @override
  String get restoreEmailBody =>
      'Saisis l\'e-mail utilisé lors du paiement. Nous t\'enverrons un code à usage unique.';

  @override
  String get restoreEmailField => 'E-mail';

  @override
  String get restoreEmailSend => 'Envoyer le code';

  @override
  String get restoreEmailSent =>
      'Si cet e-mail correspond à un achat, un code est en route. Vérifie ta boîte de réception (et tes spams).';

  @override
  String get restoreEmailCodeField => 'Code';

  @override
  String get restoreEmailConfirm => 'Restaurer';

  @override
  String get restoreEmailBadCode => 'Ce code est incorrect ou a expiré.';

  @override
  String get restoreEmailError => 'Une erreur s\'est produite. Réessaie.';

  @override
  String commonCouldNotOpen(String url) {
    return 'Impossible d\'ouvrir $url';
  }

  @override
  String get onbHookTitle =>
      'Lis les chansons que tu aimes\ndans leur propre alphabet';

  @override
  String get onbHookBody =>
      'Le hangul est l\'écriture la plus facile au monde à apprendre — ses lettres s\'emboîtent comme des briques.';

  @override
  String get onbPromiseTitle => 'Lis le hangul\nen 7 jours';

  @override
  String get onbPromiseFooter =>
      'Joue, tout simplement. On s\'occupe du reste.';

  @override
  String get onbNotifTitle => '5 minutes par jour\npour garder ta série';

  @override
  String get onbNotifBody =>
      'Envie d\'un petit rappel le soir ? C\'est facultatif.';

  @override
  String get onbAllowReminders => 'Autoriser les rappels';

  @override
  String get onbGetStarted => 'Commencer';

  @override
  String get onbChooseLanguage => 'Choisis ta langue';

  @override
  String trackerHeader(int day) {
    return 'LIS LE HANGUL EN 7 JOURS · JOUR $day';
  }

  @override
  String get trackerDay1Title => 'Découvre les consonnes';

  @override
  String get trackerDay1Goal => 'Reconnaître 10 consonnes de base';

  @override
  String get trackerDay2Title => 'Comment marchent les voyelles';

  @override
  String get trackerDay2Goal => '6 voyelles de base + ta première syllabe';

  @override
  String get trackerDay3Title => 'Les briques de base';

  @override
  String get trackerDay3Goal => 'Assembler voyelles verticales et horizontales';

  @override
  String get trackerDay4Title => 'Consonnes finales';

  @override
  String get trackerDay4Goal => 'Des syllabes avec un batchim';

  @override
  String get trackerDay5Title => 'Sons délicats';

  @override
  String get trackerDay5Goal => 'Consonnes tendues et aspirées';

  @override
  String get trackerDay6Title => 'Lire des mots';

  @override
  String get trackerDay6Goal => 'Lis tes 12 premiers mots';

  @override
  String get trackerDay7Title => 'Lecteur confirmé';

  @override
  String get trackerDay7Goal => 'Déchiffre n\'importe quelle syllabe';

  @override
  String get homeLearnTitle => 'Apprendre le hangul · 한글 배우기';

  @override
  String get homeLearnSubtitle =>
      'Des lettres aux règles de lecture · 8 leçons gratuites';

  @override
  String get homeTalkTitle => 'Le coréen du quotidien · 상황별 대화';

  @override
  String get homeTalkSubtitlePremium =>
      'Café, taxi, K-dramas, événements de fans et plus';

  @override
  String get homeTalkSubtitleFree =>
      '3 conversations gratuites · plus avec Premium';

  @override
  String get homeExploreTitle => 'Découvrir la Corée · 한국 둘러보기';

  @override
  String get homeExploreSubtitle =>
      'Applis de voyage, histoire et plats à goûter';

  @override
  String get homeDailyTitle => 'Défi du jour';

  @override
  String get homeDailySubtitle => 'Garde ta série avec une manche mixte';

  @override
  String get homeStages => 'Étapes';

  @override
  String get homeCodex => 'Codex des lettres';

  @override
  String homeCodexCount(int count) {
    return '$count / 67 cartes';
  }

  @override
  String get homeReview => 'Révision intelligente';

  @override
  String get homeReviewUnlimited => 'Illimitée';

  @override
  String homeReviewFreeToday(int used) {
    return 'Gratuit aujourd\'hui $used/1';
  }

  @override
  String get homeLeague => 'Ligue hebdo · Céladon';

  @override
  String get homeLeagueYou => 'Toi';

  @override
  String get homeSpeechUnsupported =>
      'La prononciation n\'est pas prise en charge sur cet appareil';

  @override
  String get homeNotSupported => 'Non pris en charge sur cet appareil';

  @override
  String get stageJamoHunt => 'Chasse aux jamo';

  @override
  String get stageJamoHuntSub => 'Écoute un son, touche la lettre';

  @override
  String get stageLetterBuilder => 'Atelier des lettres';

  @override
  String get stageLetterBuilderSub => 'Assemble les lettres en syllabes';

  @override
  String get stageWordRush => 'Course aux mots';

  @override
  String get stageWordRushSub => 'Lis des mots, associe les images';

  @override
  String get stagePronunciation => 'Prononciation';

  @override
  String get stagePronunciationSub => 'Fais noter ta prononciation';

  @override
  String get miniJamoTitle => 'Des lettres qui dessinent les sons';

  @override
  String get miniJamoBody =>
      'ㄱ montre la langue qui bloque la gorge, ㅁ montre les lèvres.\nLes consonnes coréennes sont des dessins de ta bouche.';

  @override
  String get miniJamoPrompt => 'Touche pour entendre le son';

  @override
  String get miniBuilderTitle =>
      'Pourquoi le hangul s\'empile comme des briques ?';

  @override
  String get miniBuilderBody =>
      'Consonne initiale, voyelle et consonne finale s\'empilent en un seul bloc.\nLa forme de la voyelle décide de la disposition.';

  @override
  String get miniBuilderPrompt => 'Touche pour construire la syllabe';

  @override
  String get miniWordTitle => 'Maintenant, lis de vrais mots';

  @override
  String get miniWordBody =>
      'Si tu sais le construire, tu sais le lire.\nLis vite et choisis l\'image qui correspond.';

  @override
  String get miniWordPrompt => 'Touche pour former le mot';

  @override
  String get miniSpeakTitle => 'Prêt à le dire à voix haute ?';

  @override
  String get miniSpeakBody =>
      'Pour finir, on parle. Dis-le dans le micro et\non note les sons que tu as réussis.';

  @override
  String get miniSpeakPrompt => 'Touche pour écouter d\'abord';

  @override
  String get miniSkip => 'Passer →';

  @override
  String miniStartsIn(int seconds) {
    return 'Début dans $seconds s';
  }

  @override
  String get miniTapToReplay => 'Touche pour réécouter';

  @override
  String get jamoHuntPrompt => 'Trouve la lettre de ce son';

  @override
  String comboActive(int multiplier, int combo) {
    return 'x$multiplier Combo $combo';
  }

  @override
  String comboIdle(int combo) {
    return 'Combo $combo';
  }

  @override
  String get builderPrompt => 'Écoute et construis la syllabe';

  @override
  String get slotInitial => 'Initiale';

  @override
  String get slotVowel => 'Voyelle';

  @override
  String get slotFinal => 'Finale';

  @override
  String get wordRushPrompt => 'Lis-le, puis choisis l\'image qui correspond';

  @override
  String get pronMicNeeded => 'Accès au micro nécessaire';

  @override
  String get pronMicBody =>
      'Le micro sert uniquement à la notation et\nles enregistrements ne sont jamais conservés.\nAutorise le micro dans les réglages de ton navigateur ou de ton appareil.';

  @override
  String get pronListenThenSay => 'Écoute, puis répète';

  @override
  String get pronTryAgainNext => 'Réessayer / Suivant';

  @override
  String resultXp(int points) {
    return '+$points XP';
  }

  @override
  String resultBestCombo(int combo) {
    return 'Meilleur combo $combo';
  }

  @override
  String resultNewCards(int count, String letters) {
    return 'Nouvelles cartes du codex : $count · $letters';
  }

  @override
  String get resultToReview => 'Sons à revoir';

  @override
  String get resultMissedHint =>
      'Les lettres que tu rates reviendront plus souvent';

  @override
  String get resultNextLevel => 'Niveau suivant';

  @override
  String get reviewComplete => 'Révision terminée !';

  @override
  String reviewScore(int correct, int total) {
    return '$correct / $total bonnes réponses';
  }

  @override
  String get reviewTeaserUsed =>
      'Révision gratuite utilisée pour aujourd\'hui.\nPremium débloque les révisions illimitées.';

  @override
  String get reviewUnlockUnlimited => 'Débloquer la révision illimitée';

  @override
  String reviewHeader(int n, int total) {
    return 'Révision intelligente  $n/$total';
  }

  @override
  String get reviewQuestion => 'Quelle lettre fait ce son ?';

  @override
  String codexTitle(int found, int total) {
    return 'Codex des lettres  $found/$total';
  }

  @override
  String get codexInitials => 'Consonnes initiales';

  @override
  String get codexVowels => 'Voyelles';

  @override
  String get codexFinals => 'Consonnes finales';

  @override
  String get codexEmptyHint =>
      'Trouve un son correct dans Chasse aux jamo pour débloquer ta première carte.';

  @override
  String get codexLocked => 'Verrouillée';

  @override
  String get codexMastered => '★ Maîtrisée';

  @override
  String get codexVelar =>
      'En forme de racine de la langue qui bloque la gorge';

  @override
  String get codexAlveolar =>
      'En forme de pointe de la langue touchant les gencives';

  @override
  String get codexLabial => 'En forme de lèvres';

  @override
  String get codexDental => 'En forme de dent';

  @override
  String get codexGlottal => 'En forme de gorge';

  @override
  String codexCheonjiin(String parts) {
    return 'Formée du ciel (ㆍ), de la terre (ㅡ) et de l\'humain (ㅣ) : $parts';
  }

  @override
  String get codexFinalSound => 'Le son qu\'elle produit en consonne finale';

  @override
  String get codexHearIt => 'Écouter';

  @override
  String get learnTitle => 'Apprendre le hangul · 한글 배우기';

  @override
  String get learnIntro =>
      'Tout ce qu\'il faut pour lire le coréen, en 8 courtes leçons.';

  @override
  String learnNext(String title) {
    return 'Suivant : $title';
  }

  @override
  String get learnBackToLessons => 'Retour aux leçons';

  @override
  String get learnLayoutTall =>
      'voyelle verticale : consonne à gauche, voyelle à droite';

  @override
  String get learnLayoutFlat =>
      'voyelle horizontale : consonne en haut, voyelle en dessous';

  @override
  String get learnLayoutMixed =>
      'voyelle composée : s\'enroule en dessous et à droite';

  @override
  String get learnPickInitial => '1. Première consonne';

  @override
  String get learnPickVowel => '2. Voyelle';

  @override
  String get learnPickFinal => '3. Consonne finale (facultative)';

  @override
  String learnExample(String words) {
    return 'ex. $words';
  }

  @override
  String get talkTitle => 'Le coréen du quotidien · 상황별 대화';

  @override
  String get talkIntro =>
      'Des phrases pour les situations que tu vivras vraiment — touche une ligne pour l\'écouter.';

  @override
  String get talkRomanization => 'Romanisation';

  @override
  String get talkKeyPhrases => 'Phrases clés';

  @override
  String get talkCultureTip => 'Astuce culture';

  @override
  String get exploreTitle => 'Découvrir la Corée · 한국 둘러보기';

  @override
  String get exploreTabApps => 'Applis';

  @override
  String get exploreTabHistory => 'Histoire';

  @override
  String get exploreTabFood => 'Cuisine';

  @override
  String get exploreTabSaju => 'Saju';

  @override
  String get exploreAppsIntro =>
      'Installe-les avant de partir — elles rendent la Corée facile.';

  @override
  String exploreTip(String tip) {
    return 'Astuce : $tip';
  }

  @override
  String get exploreHistoryIntro => '5 000 ans en 11 étapes.';

  @override
  String get exploreFoodIntro =>
      'Les plats à ne pas manquer. Touche un bouton de carte pour voir les adresses les mieux notées près de toi en ce moment — des notes en direct, toujours à jour.';

  @override
  String get exploreNaverEnglish =>
      'Naver Map en anglais : dans l\'appli, va dans MY → Paramètres → Langue → English.';

  @override
  String exploreWhere(String place) {
    return 'Où : $place';
  }

  @override
  String get exploreSajuIntro =>
      'Le saju (사주) est l\'art divinatoire coréen fondé sur les « quatre piliers » de ta naissance : année, mois, jour et heure. Les couples vérifient leur compatibilité — 궁합 — avant les grandes décisions.';

  @override
  String get exploreViewOnEtsy => 'Voir sur Etsy';

  @override
  String get paywallTitle => 'Lis le hangul jusqu\'au bout';

  @override
  String get paywallPronWeb =>
      'Notation de la prononciation (Chrome et Safari)';

  @override
  String get paywallReviewWeb =>
      'Révision intelligente illimitée des sons que tu rates';

  @override
  String get paywallStagesWeb =>
      'Tous les niveaux de l\'Atelier des lettres, plus la Course aux mots';

  @override
  String get paywallStreakWeb => 'Réparation de série pour protéger ta série';

  @override
  String get paywallPronApp =>
      'Notation de la prononciation pour chaque lettre';

  @override
  String get paywallReviewApp => 'Révision intelligente des sons que tu rates';

  @override
  String get paywallStagesApp =>
      'Toutes les étapes, de la construction des lettres à la lecture des mots';

  @override
  String get paywallLoadError => 'Impossible de charger les offres';

  @override
  String get paywallNotCompleted => 'Le paiement n\'a pas abouti';

  @override
  String get paywallError => 'Erreur de paiement. Réessaie dans un instant';

  @override
  String get paywallProcessing => 'Traitement…';

  @override
  String paywallStartTrial(int days) {
    return 'Commencer l\'essai gratuit de $days jours';
  }

  @override
  String get paywallUnlock => 'Débloquer Premium';

  @override
  String get paywallLifetimeTerms =>
      'Paiement unique · Sans abonnement · À toi pour toujours';

  @override
  String paywallTrialTerms(String price) {
    return 'Puis $price, renouvellement automatique · Résiliable à tout moment';
  }

  @override
  String paywallRenewTerms(String price) {
    return '$price, renouvellement automatique · Résiliable à tout moment';
  }

  @override
  String get paywallDemo =>
      'Paiement de démonstration : tu ne seras pas débité';

  @override
  String get paywallHowToCancel => 'Comment résilier';

  @override
  String get planLifetime => 'À vie';

  @override
  String get planYearly => 'Annuel';

  @override
  String get planMonthly => 'Mensuel';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsMusic => 'Musique';

  @override
  String get settingsSfx => 'Effets sonores';

  @override
  String get settingsVoice => 'Voix';

  @override
  String get settingsMuteAll => 'Tout couper';

  @override
  String get settingsPremiumActive => 'Premium actif';

  @override
  String get settingsFreePlan => 'Offre gratuite';

  @override
  String settingsBilling(String backend) {
    return 'Facturation : $backend';
  }

  @override
  String get settingsUnlockAll => 'Débloque toutes les étapes avec Premium';

  @override
  String get cancelTitle => 'Tu peux résilier à tout moment';

  @override
  String get cancelBody =>
      '· Les abonnements se renouvellent automatiquement, sauf résiliation au moins 24 heures avant la fin de la période en cours.\n\n· iPhone : Réglages → Apple ID → Abonnements → Hangul Bricks → Annuler\n· Web : utilise le lien figurant dans ton e-mail de reçu Lemon Squeezy\n\n· Après la résiliation, Premium reste actif jusqu\'à la fin de la période payée.\n\n· Si tu résilies pendant l\'essai gratuit, tu ne seras pas débité.';

  @override
  String get cancelOpenSettings => 'Ouvrir les réglages d\'abonnement';

  @override
  String cancelStoreNote(String channel) {
    return 'Les versions des stores ouvrent les réglages d\'abonnement du système (canal actuel : $channel)';
  }

  @override
  String get privacyWeb =>
      '· Ta progression et tes erreurs sont enregistrées uniquement dans ce navigateur. Aucun compte nécessaire.\n\n· Pour la notation de la prononciation, ta voix est envoyée au service vocal du navigateur (Google dans Chrome, Apple dans Safari) pour être convertie en texte. Elle n\'atteint jamais les serveurs de Hangul Bricks et les enregistrements ne sont pas conservés.\n\n· Le micro sert uniquement à la notation de la prononciation. Si tu le refuses, tout le reste fonctionne quand même.\n\n· Les paiements sont gérés par notre revendeur Lemon Squeezy, et l\'appli n\'a jamais accès aux données de ta carte.\n\n· Si tu utilises « Restaurer par e-mail », l\'adresse saisie est envoyée aux serveurs de Hangul Bricks pour retrouver ton achat chez Lemon Squeezy, et le code à usage unique est envoyé par notre prestataire d\'e-mail Resend. L\'adresse n\'est pas conservée.';

  @override
  String get privacyApp =>
      '· Ta progression et tes erreurs sont enregistrées uniquement sur cet appareil. Aucun compte nécessaire.\n\n· L\'audio de prononciation est analysé uniquement sur l\'appareil, et les enregistrements ne sont jamais conservés ni envoyés.\n\n· Le micro sert uniquement à la notation de la prononciation. Si tu le refuses, tout le reste fonctionne quand même.\n\n· Les paiements passent par l\'achat intégré de l\'App Store, et l\'appli n\'a jamais accès aux données de ta carte.';

  @override
  String get termsBody =>
      '· L\'utilisation de Hangul Bricks est régie par le CLUF standard d\'Apple et par nos Conditions d\'utilisation web.\n\n· À vie : paiement unique — sans abonnement, sans renouvellement.\n\n· L\'offre mensuelle se renouvelle automatiquement au même prix, sauf résiliation au moins 24 heures avant la fin de la période en cours.\n\n· Si tu résilies pendant l\'essai gratuit, tu ne seras pas débité.';
}
