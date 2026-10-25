// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class L10nEs extends L10n {
  L10nEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Hangul Bricks';

  @override
  String get language => 'Idioma';

  @override
  String get languageFollowDevice => 'Idioma del dispositivo';

  @override
  String get commonNext => 'Siguiente';

  @override
  String get commonSkip => 'Omitir';

  @override
  String get commonPlay => 'Jugar';

  @override
  String get commonGo => 'Ir';

  @override
  String get commonBackToMap => 'Volver al mapa';

  @override
  String get commonFree => 'GRATIS';

  @override
  String get commonRestorePurchase => 'Restaurar compra';

  @override
  String get commonPrivacyPolicy => 'Política de privacidad';

  @override
  String get commonTermsOfUse => 'Términos de uso';

  @override
  String get commonManageSubscription => 'Administrar suscripción';

  @override
  String get commonReadFullText => 'Leer el texto completo';

  @override
  String get commonSummary => 'Resumen';

  @override
  String get commonSubscriptionRestored => 'Suscripción restaurada';

  @override
  String get commonNoSubscription =>
      'No hay ninguna suscripción para restaurar';

  @override
  String get restoreEmailAction => 'Restaurar con email';

  @override
  String get restoreEmailBody =>
      'Introduce el email que usaste al pagar. Te enviaremos un código de un solo uso.';

  @override
  String get restoreEmailField => 'Email';

  @override
  String get restoreEmailSend => 'Enviar código';

  @override
  String get restoreEmailSent =>
      'Si este email tiene una compra, el código va en camino. Revisa tu bandeja de entrada (y la carpeta de spam).';

  @override
  String get restoreEmailCodeField => 'Código';

  @override
  String get restoreEmailConfirm => 'Restaurar';

  @override
  String get restoreEmailBadCode => 'El código es incorrecto o ha caducado.';

  @override
  String get restoreEmailError => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String commonCouldNotOpen(String url) {
    return 'No se pudo abrir $url';
  }

  @override
  String get onbHookTitle =>
      'Lee las canciones que amas\nen sus propias letras';

  @override
  String get onbHookBody =>
      'El hangul es el alfabeto más fácil de aprender del mundo: sus letras encajan como bloques.';

  @override
  String get onbPromiseTitle => 'Lee hangul\nen 7 días';

  @override
  String get onbPromiseFooter =>
      'Solo juega. Nosotros nos encargamos del resto.';

  @override
  String get onbNotifTitle => '5 minutos al día\nmantienen viva tu racha';

  @override
  String get onbNotifBody =>
      '¿Quieres un recordatorio suave por la noche? Es opcional.';

  @override
  String get onbAllowReminders => 'Permitir recordatorios';

  @override
  String get onbGetStarted => 'Comenzar';

  @override
  String get onbChooseLanguage => 'Elige tu idioma';

  @override
  String trackerHeader(int day) {
    return 'LEE HANGUL EN 7 DÍAS · DÍA $day';
  }

  @override
  String get trackerDay1Title => 'Conoce las consonantes';

  @override
  String get trackerDay1Goal => 'Reconoce 10 consonantes básicas';

  @override
  String get trackerDay2Title => 'Cómo funcionan las vocales';

  @override
  String get trackerDay2Goal => '6 vocales básicas + tu primera sílaba';

  @override
  String get trackerDay3Title => 'Bloques de construcción';

  @override
  String get trackerDay3Goal => 'Combina vocales verticales y horizontales';

  @override
  String get trackerDay4Title => 'Consonantes finales';

  @override
  String get trackerDay4Goal => 'Sílabas con batchim';

  @override
  String get trackerDay5Title => 'Sonidos difíciles';

  @override
  String get trackerDay5Goal => 'Consonantes tensas y aspiradas';

  @override
  String get trackerDay6Title => 'Leer palabras';

  @override
  String get trackerDay6Goal => 'Lee tus primeras 12 palabras';

  @override
  String get trackerDay7Title => 'Lector con fluidez';

  @override
  String get trackerDay7Goal => 'Pronuncia cualquier sílaba';

  @override
  String get homeLearnTitle => 'Aprende hangul · 한글 배우기';

  @override
  String get homeLearnSubtitle =>
      'De cada letra a las reglas de lectura · 8 lecciones gratis';

  @override
  String get homeTalkTitle => 'Coreano de la vida real · 상황별 대화';

  @override
  String get homeTalkSubtitlePremium =>
      'Cafetería, taxi, K-dramas, eventos de fans y más';

  @override
  String get homeTalkSubtitleFree =>
      '3 conversaciones gratis · más con Premium';

  @override
  String get homeExploreTitle => 'Explora Corea · 한국 둘러보기';

  @override
  String get homeExploreSubtitle =>
      'Apps de viaje, historia y comida para probar';

  @override
  String get homeDailyTitle => 'Reto diario';

  @override
  String get homeDailySubtitle => 'Mantén tu racha con una ronda mixta';

  @override
  String get homeStages => 'Etapas';

  @override
  String get homeCodex => 'Códice de letras';

  @override
  String homeCodexCount(int count) {
    return '$count / 67 tarjetas';
  }

  @override
  String get homeReview => 'Repaso inteligente';

  @override
  String get homeReviewUnlimited => 'Ilimitado';

  @override
  String homeReviewFreeToday(int used) {
    return 'Gratis hoy $used/1';
  }

  @override
  String get homeLeague => 'Liga semanal · Celadón';

  @override
  String get homeLeagueYou => 'Tú';

  @override
  String get homeSpeechUnsupported =>
      'La pronunciación no es compatible con este dispositivo';

  @override
  String get homeNotSupported => 'No compatible con este dispositivo';

  @override
  String get stageJamoHunt => 'Caza de jamo';

  @override
  String get stageJamoHuntSub => 'Escucha un sonido y toca la letra';

  @override
  String get stageLetterBuilder => 'Constructor de letras';

  @override
  String get stageLetterBuilderSub => 'Encaja letras para formar sílabas';

  @override
  String get stageWordRush => 'Carrera de palabras';

  @override
  String get stageWordRushSub => 'Lee palabras y relaciónalas con imágenes';

  @override
  String get stagePronunciation => 'Pronunciación';

  @override
  String get stagePronunciationSub =>
      'Recibe una puntuación de tu pronunciación';

  @override
  String get miniJamoTitle => 'Letras que dibujan sonidos';

  @override
  String get miniJamoBody =>
      'ㄱ muestra la lengua bloqueando la garganta; ㅁ muestra los labios.\nLas consonantes coreanas son dibujos de tu boca.';

  @override
  String get miniJamoPrompt => 'Toca para escuchar el sonido';

  @override
  String get miniBuilderTitle => '¿Por qué el hangul se apila como bloques?';

  @override
  String get miniBuilderBody =>
      'La letra inicial, la vocal y la final se apilan en un solo bloque.\nLa forma de la vocal decide la distribución.';

  @override
  String get miniBuilderPrompt => 'Toca para formar la sílaba';

  @override
  String get miniWordTitle => 'Ahora lee palabras reales';

  @override
  String get miniWordBody =>
      'Si puedes armarla, puedes leerla.\nLee rápido y elige la imagen correcta.';

  @override
  String get miniWordPrompt => 'Toca para formar la palabra';

  @override
  String get miniSpeakTitle => '¿Listo para decirlo en voz alta?';

  @override
  String get miniSpeakBody =>
      'Al final toca hablar. Dilo al micrófono y\nte diremos qué sonidos clavaste.';

  @override
  String get miniSpeakPrompt => 'Toca para escuchar primero';

  @override
  String get miniSkip => 'Omitir →';

  @override
  String miniStartsIn(int seconds) {
    return 'Empieza en $seconds s';
  }

  @override
  String get miniTapToReplay => 'Toca para repetir';

  @override
  String get jamoHuntPrompt => 'Encuentra la letra de este sonido';

  @override
  String comboActive(int multiplier, int combo) {
    return 'x$multiplier Combo $combo';
  }

  @override
  String comboIdle(int combo) {
    return 'Combo $combo';
  }

  @override
  String get builderPrompt => 'Escucha y forma la sílaba';

  @override
  String get slotInitial => 'Inicial';

  @override
  String get slotVowel => 'Vocal';

  @override
  String get slotFinal => 'Final';

  @override
  String get wordRushPrompt => 'Léela y elige la imagen correcta';

  @override
  String get pronMicNeeded => 'Se necesita acceso al micrófono';

  @override
  String get pronMicBody =>
      'El micrófono se usa solo para puntuar y\nlas grabaciones nunca se guardan.\nPermite el micrófono en la configuración de tu navegador o dispositivo.';

  @override
  String get pronListenThenSay => 'Escucha y luego dilo';

  @override
  String get pronTryAgainNext => 'Reintentar / Siguiente';

  @override
  String resultXp(int points) {
    return '+$points XP';
  }

  @override
  String resultBestCombo(int combo) {
    return 'Mejor combo $combo';
  }

  @override
  String resultNewCards(int count, String letters) {
    return 'Nuevas tarjetas del códice: $count · $letters';
  }

  @override
  String get resultToReview => 'Sonidos para repasar';

  @override
  String get resultMissedHint =>
      'Las letras que falles aparecerán con más frecuencia';

  @override
  String get resultNextLevel => 'Siguiente nivel';

  @override
  String get reviewComplete => '¡Repaso completado!';

  @override
  String reviewScore(int correct, int total) {
    return '$correct / $total correctas';
  }

  @override
  String get reviewTeaserUsed =>
      'Ya usaste el repaso gratis de hoy.\nPremium desbloquea repasos ilimitados.';

  @override
  String get reviewUnlockUnlimited => 'Desbloquear repaso ilimitado';

  @override
  String reviewHeader(int n, int total) {
    return 'Repaso inteligente  $n/$total';
  }

  @override
  String get reviewQuestion => '¿Qué letra hace este sonido?';

  @override
  String codexTitle(int found, int total) {
    return 'Códice de letras  $found/$total';
  }

  @override
  String get codexInitials => 'Consonantes iniciales';

  @override
  String get codexVowels => 'Vocales';

  @override
  String get codexFinals => 'Consonantes finales';

  @override
  String get codexEmptyHint =>
      'Acierta un sonido en Caza de jamo para desbloquear tu primera tarjeta.';

  @override
  String get codexLocked => 'Bloqueada';

  @override
  String get codexMastered => '★ Dominada';

  @override
  String get codexVelar =>
      'Con la forma de la raíz de la lengua bloqueando la garganta';

  @override
  String get codexAlveolar =>
      'Con la forma de la punta de la lengua tocando las encías';

  @override
  String get codexLabial => 'Con la forma de los labios';

  @override
  String get codexDental => 'Con la forma de un diente';

  @override
  String get codexGlottal => 'Con la forma de la garganta';

  @override
  String codexCheonjiin(String parts) {
    return 'Formada por cielo (ㆍ), tierra (ㅡ) y persona (ㅣ): $parts';
  }

  @override
  String get codexFinalSound => 'El sonido que hace como consonante final';

  @override
  String get codexHearIt => 'Escuchar';

  @override
  String get learnTitle => 'Aprende hangul · 한글 배우기';

  @override
  String get learnIntro =>
      'Todo lo que necesitas para leer coreano, en 8 lecciones cortas.';

  @override
  String learnNext(String title) {
    return 'Siguiente: $title';
  }

  @override
  String get learnBackToLessons => 'Volver a las lecciones';

  @override
  String get learnLayoutTall =>
      'vocal vertical: consonante a la izquierda, vocal a la derecha';

  @override
  String get learnLayoutFlat =>
      'vocal horizontal: consonante arriba, vocal abajo';

  @override
  String get learnLayoutMixed =>
      'vocal combinada: rodea por abajo y a la derecha';

  @override
  String get learnPickInitial => '1. Primera consonante';

  @override
  String get learnPickVowel => '2. Vocal';

  @override
  String get learnPickFinal => '3. Consonante final (opcional)';

  @override
  String learnExample(String words) {
    return 'p. ej. $words';
  }

  @override
  String get talkTitle => 'Coreano de la vida real · 상황별 대화';

  @override
  String get talkIntro =>
      'Frases para los momentos que realmente vivirás: toca cualquier línea para escucharla.';

  @override
  String get talkRomanization => 'Romanización';

  @override
  String get talkKeyPhrases => 'Frases clave';

  @override
  String get talkCultureTip => 'Consejo cultural';

  @override
  String get exploreTitle => 'Explora Corea · 한국 둘러보기';

  @override
  String get exploreTabApps => 'Apps';

  @override
  String get exploreTabHistory => 'Historia';

  @override
  String get exploreTabFood => 'Comida';

  @override
  String get exploreTabSaju => 'Saju';

  @override
  String get exploreAppsIntro =>
      'Instálalas antes de volar: hacen que Corea sea fácil.';

  @override
  String exploreTip(String tip) {
    return 'Consejo: $tip';
  }

  @override
  String get exploreHistoryIntro => '5000 años en 11 paradas.';

  @override
  String get exploreFoodIntro =>
      'Platos imperdibles. Toca un botón de mapa para ver los lugares mejor calificados cerca de ti ahora mismo: calificaciones en vivo, siempre actualizadas.';

  @override
  String get exploreNaverEnglish =>
      'Naver Map en inglés: en la app ve a MY → Settings → Language → English.';

  @override
  String exploreWhere(String place) {
    return 'Dónde: $place';
  }

  @override
  String get exploreSajuIntro =>
      'El saju (사주) es la lectura de la fortuna coreana basada en los \"cuatro pilares\" de tu año, mes, día y hora de nacimiento. Las parejas revisan su compatibilidad —궁합— antes de tomar decisiones importantes.';

  @override
  String get exploreViewOnEtsy => 'Ver en Etsy';

  @override
  String get paywallTitle => 'Lee hangul por completo';

  @override
  String get paywallPronWeb => 'Puntuación de pronunciación (Chrome y Safari)';

  @override
  String get paywallReviewWeb =>
      'Repaso inteligente ilimitado de los sonidos que fallas';

  @override
  String get paywallStagesWeb =>
      'Todos los niveles de Constructor de letras y Carrera de palabras';

  @override
  String get paywallStreakWeb => 'Reparación de racha para proteger tu racha';

  @override
  String get paywallPronApp => 'Puntuación de pronunciación para cada letra';

  @override
  String get paywallReviewApp => 'Repaso inteligente de los sonidos que fallas';

  @override
  String get paywallStagesApp =>
      'Todas las etapas, desde formar letras hasta leer palabras';

  @override
  String get paywallLoadError => 'No se pudieron cargar los planes';

  @override
  String get paywallNotCompleted => 'El pago no se completó';

  @override
  String get paywallError =>
      'Error en el pago. Inténtalo de nuevo en unos momentos';

  @override
  String get paywallProcessing => 'Procesando…';

  @override
  String paywallStartTrial(int days) {
    return 'Comenzar prueba gratis de $days días';
  }

  @override
  String get paywallUnlock => 'Desbloquear Premium';

  @override
  String get paywallLifetimeTerms =>
      'Pago único · Sin suscripción · Tuyo para siempre';

  @override
  String paywallTrialTerms(String price) {
    return 'Luego $price, se renueva automáticamente · Cancela cuando quieras';
  }

  @override
  String paywallRenewTerms(String price) {
    return '$price, se renueva automáticamente · Cancela cuando quieras';
  }

  @override
  String get paywallDemo => 'Pago de demostración: no se te cobrará';

  @override
  String get paywallHowToCancel => 'Cómo cancelar';

  @override
  String get planLifetime => 'De por vida';

  @override
  String get planYearly => 'Anual';

  @override
  String get planMonthly => 'Mensual';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsMusic => 'Música';

  @override
  String get settingsSfx => 'Efectos de sonido';

  @override
  String get settingsVoice => 'Voz';

  @override
  String get settingsMuteAll => 'Silenciar todo';

  @override
  String get settingsPremiumActive => 'Premium activo';

  @override
  String get settingsFreePlan => 'Plan gratuito';

  @override
  String settingsBilling(String backend) {
    return 'Facturación: $backend';
  }

  @override
  String get settingsUnlockAll => 'Desbloquea todas las etapas con Premium';

  @override
  String get cancelTitle => 'Puedes cancelar cuando quieras';

  @override
  String get cancelBody =>
      '· Las suscripciones se renuevan automáticamente a menos que se cancelen al menos 24 horas antes de que termine el período.\n\n· iPhone: Configuración → Apple ID → Suscripciones → Hangul Bricks → Cancelar\n· Web: usa el enlace del correo con tu recibo de Lemon Squeezy\n\n· Después de cancelar, Premium sigue activo hasta que termine el período pagado.\n\n· Si cancelas durante la prueba gratis, no se te cobrará.';

  @override
  String get cancelOpenSettings => 'Abrir configuración de suscripción';

  @override
  String cancelStoreNote(String channel) {
    return 'Las versiones de tienda abren la configuración de suscripciones del sistema (canal actual: $channel)';
  }

  @override
  String get privacyWeb =>
      '· Tu progreso y tus errores se guardan solo en este navegador. No necesitas una cuenta.\n\n· Para puntuar la pronunciación, tu voz se envía al servicio de voz del navegador (Google en Chrome, Apple en Safari) para convertirla en texto. Nunca llega a los servidores de Hangul Bricks y las grabaciones no se guardan.\n\n· El micrófono se usa solo para puntuar la pronunciación. Si no lo permites, todo lo demás sigue funcionando.\n\n· Los pagos los gestiona nuestro revendedor Lemon Squeezy, y la app nunca ve los datos de tu tarjeta.\n\n· Si usas «Restaurar con email», el email que introduces se envía a los servidores de Hangul Bricks para buscar tu compra en Lemon Squeezy, y el código de un solo uso lo entrega nuestro proveedor de email, Resend. El email no se guarda.';

  @override
  String get privacyApp =>
      '· Tu progreso y tus errores se guardan solo en este dispositivo. No necesitas una cuenta.\n\n· El audio de pronunciación se analiza solo en el dispositivo, y las grabaciones nunca se guardan ni se suben.\n\n· El micrófono se usa solo para puntuar la pronunciación. Si no lo permites, todo lo demás sigue funcionando.\n\n· Los pagos se realizan mediante compras dentro de la app del App Store, y la app nunca ve los datos de tu tarjeta.';

  @override
  String get termsBody =>
      '· El uso de Hangul Bricks se rige por el EULA estándar de Apple y nuestros Términos de servicio web.\n\n· De por vida: pago único, sin suscripción ni renovación.\n\n· El plan mensual se renueva automáticamente al mismo precio a menos que se cancele al menos 24 horas antes de que termine el período.\n\n· Si cancelas durante la prueba gratis, no se te cobrará.';
}
