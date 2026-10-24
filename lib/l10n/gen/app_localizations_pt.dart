// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class L10nPt extends L10n {
  L10nPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Hangul Bricks';

  @override
  String get language => 'Idioma';

  @override
  String get languageFollowDevice => 'Idioma do dispositivo';

  @override
  String get commonNext => 'Próximo';

  @override
  String get commonSkip => 'Pular';

  @override
  String get commonPlay => 'Jogar';

  @override
  String get commonGo => 'Ir';

  @override
  String get commonBackToMap => 'Voltar ao mapa';

  @override
  String get commonFree => 'GRÁTIS';

  @override
  String get commonRestorePurchase => 'Restaurar compra';

  @override
  String get commonPrivacyPolicy => 'Política de Privacidade';

  @override
  String get commonTermsOfUse => 'Termos de Uso';

  @override
  String get commonManageSubscription => 'Gerenciar assinatura';

  @override
  String get commonReadFullText => 'Ler o texto completo';

  @override
  String get commonSummary => 'Resumo';

  @override
  String get commonSubscriptionRestored => 'Assinatura restaurada';

  @override
  String get commonNoSubscription => 'Nenhuma assinatura para restaurar';

  @override
  String commonCouldNotOpen(String url) {
    return 'Não foi possível abrir $url';
  }

  @override
  String get onbHookTitle =>
      'Leia as músicas que você ama\nnas letras originais';

  @override
  String get onbHookBody =>
      'O hangul é o alfabeto mais fácil de aprender do mundo: suas letras se encaixam como blocos.';

  @override
  String get onbPromiseTitle => 'Leia hangul\nem 7 dias';

  @override
  String get onbPromiseFooter => 'É só jogar. A gente cuida do resto.';

  @override
  String get onbNotifTitle => '5 minutos por dia\nmantêm sua sequência viva';

  @override
  String get onbNotifBody => 'Quer um lembrete gentil à noite? É opcional.';

  @override
  String get onbAllowReminders => 'Permitir lembretes';

  @override
  String get onbGetStarted => 'Começar';

  @override
  String get onbChooseLanguage => 'Escolha seu idioma';

  @override
  String trackerHeader(int day) {
    return 'LEIA HANGUL EM 7 DIAS · DIA $day';
  }

  @override
  String get trackerDay1Title => 'Conheça as consoantes';

  @override
  String get trackerDay1Goal => 'Reconheça 10 consoantes básicas';

  @override
  String get trackerDay2Title => 'Como as vogais funcionam';

  @override
  String get trackerDay2Goal => '6 vogais básicas + sua primeira sílaba';

  @override
  String get trackerDay3Title => 'Blocos de montar';

  @override
  String get trackerDay3Goal => 'Combine vogais verticais e horizontais';

  @override
  String get trackerDay4Title => 'Consoantes finais';

  @override
  String get trackerDay4Goal => 'Sílabas com batchim';

  @override
  String get trackerDay5Title => 'Sons difíceis';

  @override
  String get trackerDay5Goal => 'Consoantes tensas e aspiradas';

  @override
  String get trackerDay6Title => 'Lendo palavras';

  @override
  String get trackerDay6Goal => 'Leia suas primeiras 12 palavras';

  @override
  String get trackerDay7Title => 'Leitor fluente';

  @override
  String get trackerDay7Goal => 'Pronuncie qualquer sílaba';

  @override
  String get homeLearnTitle => 'Aprenda hangul · 한글 배우기';

  @override
  String get homeLearnSubtitle =>
      'De cada letra às regras de leitura · 8 lições grátis';

  @override
  String get homeTalkTitle => 'Coreano do dia a dia · 상황별 대화';

  @override
  String get homeTalkSubtitlePremium =>
      'Café, táxi, K-dramas, eventos de fãs e mais';

  @override
  String get homeTalkSubtitleFree => '3 conversas grátis · mais com o Premium';

  @override
  String get homeExploreTitle => 'Explore a Coreia · 한국 둘러보기';

  @override
  String get homeExploreSubtitle =>
      'Apps de viagem, história e comidas para provar';

  @override
  String get homeDailyTitle => 'Desafio diário';

  @override
  String get homeDailySubtitle => 'Mantenha sua sequência com uma rodada mista';

  @override
  String get homeStages => 'Fases';

  @override
  String get homeCodex => 'Códex de letras';

  @override
  String homeCodexCount(int count) {
    return '$count / 67 cartas';
  }

  @override
  String get homeReview => 'Revisão inteligente';

  @override
  String get homeReviewUnlimited => 'Ilimitada';

  @override
  String homeReviewFreeToday(int used) {
    return 'Grátis hoje $used/1';
  }

  @override
  String get homeLeague => 'Liga semanal · Celadon';

  @override
  String get homeLeagueYou => 'Você';

  @override
  String get homeSpeechUnsupported =>
      'A pronúncia não é compatível com este dispositivo';

  @override
  String get homeNotSupported => 'Não compatível com este dispositivo';

  @override
  String get stageJamoHunt => 'Caça ao jamo';

  @override
  String get stageJamoHuntSub => 'Ouça um som e toque na letra';

  @override
  String get stageLetterBuilder => 'Monta-letras';

  @override
  String get stageLetterBuilderSub => 'Encaixe letras para formar sílabas';

  @override
  String get stageWordRush => 'Corrida de palavras';

  @override
  String get stageWordRushSub => 'Leia palavras e combine com imagens';

  @override
  String get stagePronunciation => 'Pronúncia';

  @override
  String get stagePronunciationSub => 'Receba uma nota pela sua pronúncia';

  @override
  String get miniJamoTitle => 'Letras que desenham sons';

  @override
  String get miniJamoBody =>
      'ㄱ mostra a língua bloqueando a garganta; ㅁ mostra os lábios.\nAs consoantes coreanas são desenhos da sua boca.';

  @override
  String get miniJamoPrompt => 'Toque para ouvir o som';

  @override
  String get miniBuilderTitle => 'Por que o hangul se empilha como blocos?';

  @override
  String get miniBuilderBody =>
      'A letra inicial, a vogal e a final se empilham em um único bloco.\nO formato da vogal define a disposição.';

  @override
  String get miniBuilderPrompt => 'Toque para montar a sílaba';

  @override
  String get miniWordTitle => 'Agora leia palavras de verdade';

  @override
  String get miniWordBody =>
      'Se você consegue montar, consegue ler.\nLeia rápido e escolha a imagem certa.';

  @override
  String get miniWordPrompt => 'Toque para formar a palavra';

  @override
  String get miniSpeakTitle => 'Pronto para falar em voz alta?';

  @override
  String get miniSpeakBody =>
      'Por último, a fala. Fale no microfone e\na gente avalia quais sons você acertou em cheio.';

  @override
  String get miniSpeakPrompt => 'Toque para ouvir primeiro';

  @override
  String get miniSkip => 'Pular →';

  @override
  String miniStartsIn(int seconds) {
    return 'Começa em $seconds s';
  }

  @override
  String get miniTapToReplay => 'Toque para repetir';

  @override
  String get jamoHuntPrompt => 'Encontre a letra deste som';

  @override
  String comboActive(int multiplier, int combo) {
    return 'x$multiplier Combo $combo';
  }

  @override
  String comboIdle(int combo) {
    return 'Combo $combo';
  }

  @override
  String get builderPrompt => 'Ouça e monte a sílaba';

  @override
  String get slotInitial => 'Inicial';

  @override
  String get slotVowel => 'Vogal';

  @override
  String get slotFinal => 'Final';

  @override
  String get wordRushPrompt => 'Leia e escolha a imagem certa';

  @override
  String get pronMicNeeded => 'É preciso acesso ao microfone';

  @override
  String get pronMicBody =>
      'O microfone é usado apenas para dar a nota e\nas gravações nunca são armazenadas.\nPermita o microfone nas configurações do navegador ou do dispositivo.';

  @override
  String get pronListenThenSay => 'Ouça e depois fale';

  @override
  String get pronTryAgainNext => 'Tentar de novo / Próximo';

  @override
  String resultXp(int points) {
    return '+$points XP';
  }

  @override
  String resultBestCombo(int combo) {
    return 'Melhor combo $combo';
  }

  @override
  String resultNewCards(int count, String letters) {
    return 'Novas cartas do códex: $count · $letters';
  }

  @override
  String get resultToReview => 'Sons para revisar';

  @override
  String get resultMissedHint =>
      'As letras que você errar vão aparecer com mais frequência';

  @override
  String get resultNextLevel => 'Próximo nível';

  @override
  String get reviewComplete => 'Revisão concluída!';

  @override
  String reviewScore(int correct, int total) {
    return '$correct / $total certas';
  }

  @override
  String get reviewTeaserUsed =>
      'Você já usou a revisão grátis de hoje.\nO Premium libera revisões ilimitadas.';

  @override
  String get reviewUnlockUnlimited => 'Liberar revisão ilimitada';

  @override
  String reviewHeader(int n, int total) {
    return 'Revisão inteligente  $n/$total';
  }

  @override
  String get reviewQuestion => 'Qual letra faz este som?';

  @override
  String codexTitle(int found, int total) {
    return 'Códex de letras  $found/$total';
  }

  @override
  String get codexInitials => 'Consoantes iniciais';

  @override
  String get codexVowels => 'Vogais';

  @override
  String get codexFinals => 'Consoantes finais';

  @override
  String get codexEmptyHint =>
      'Acerte um som na Caça ao jamo para desbloquear sua primeira carta.';

  @override
  String get codexLocked => 'Bloqueada';

  @override
  String get codexMastered => '★ Dominada';

  @override
  String get codexVelar => 'No formato da raiz da língua bloqueando a garganta';

  @override
  String get codexAlveolar => 'No formato da ponta da língua tocando a gengiva';

  @override
  String get codexLabial => 'No formato dos lábios';

  @override
  String get codexDental => 'No formato de um dente';

  @override
  String get codexGlottal => 'No formato da garganta';

  @override
  String codexCheonjiin(String parts) {
    return 'Formada por céu (ㆍ), terra (ㅡ) e pessoa (ㅣ): $parts';
  }

  @override
  String get codexFinalSound => 'O som que ela faz como consoante final';

  @override
  String get codexHearIt => 'Ouvir';

  @override
  String get learnTitle => 'Aprenda hangul · 한글 배우기';

  @override
  String get learnIntro =>
      'Tudo o que você precisa para ler coreano, em 8 lições curtas.';

  @override
  String learnNext(String title) {
    return 'Próxima: $title';
  }

  @override
  String get learnBackToLessons => 'Voltar às lições';

  @override
  String get learnLayoutTall =>
      'vogal vertical: consoante à esquerda, vogal à direita';

  @override
  String get learnLayoutFlat =>
      'vogal horizontal: consoante em cima, vogal embaixo';

  @override
  String get learnLayoutMixed =>
      'vogal combinada: envolve por baixo e pela direita';

  @override
  String get learnPickInitial => '1. Primeira consoante';

  @override
  String get learnPickVowel => '2. Vogal';

  @override
  String get learnPickFinal => '3. Consoante final (opcional)';

  @override
  String learnExample(String words) {
    return 'ex.: $words';
  }

  @override
  String get talkTitle => 'Coreano do dia a dia · 상황별 대화';

  @override
  String get talkIntro =>
      'Frases para os momentos que você vai viver de verdade: toque em qualquer linha para ouvir.';

  @override
  String get talkRomanization => 'Romanização';

  @override
  String get talkKeyPhrases => 'Frases-chave';

  @override
  String get talkCultureTip => 'Dica cultural';

  @override
  String get exploreTitle => 'Explore a Coreia · 한국 둘러보기';

  @override
  String get exploreTabApps => 'Apps';

  @override
  String get exploreTabHistory => 'História';

  @override
  String get exploreTabFood => 'Comida';

  @override
  String get exploreTabSaju => 'Saju';

  @override
  String get exploreAppsIntro =>
      'Instale antes de viajar: eles deixam a Coreia muito mais fácil.';

  @override
  String exploreTip(String tip) {
    return 'Dica: $tip';
  }

  @override
  String get exploreHistoryIntro => '5.000 anos em 11 paradas.';

  @override
  String get exploreFoodIntro =>
      'Pratos imperdíveis. Toque em um botão de mapa para ver os lugares mais bem avaliados perto de você agora: avaliações ao vivo, sempre atualizadas.';

  @override
  String get exploreNaverEnglish =>
      'Naver Map em inglês: no app, vá em MY → Settings → Language → English.';

  @override
  String exploreWhere(String place) {
    return 'Onde: $place';
  }

  @override
  String get exploreSajuIntro =>
      'Saju (사주) é a leitura da sorte coreana baseada nos \"quatro pilares\" do seu ano, mês, dia e hora de nascimento. Casais conferem a compatibilidade — 궁합 — antes de grandes decisões.';

  @override
  String get exploreViewOnEtsy => 'Ver no Etsy';

  @override
  String get paywallTitle => 'Leia hangul de ponta a ponta';

  @override
  String get paywallPronWeb => 'Nota de pronúncia (Chrome e Safari)';

  @override
  String get paywallReviewWeb =>
      'Revisão inteligente ilimitada dos sons que você erra';

  @override
  String get paywallStagesWeb =>
      'Todos os níveis do Monta-letras e da Corrida de palavras';

  @override
  String get paywallStreakWeb =>
      'Reparo de sequência para proteger sua sequência';

  @override
  String get paywallPronApp => 'Nota de pronúncia para cada letra';

  @override
  String get paywallReviewApp => 'Revisão inteligente dos sons que você erra';

  @override
  String get paywallStagesApp =>
      'Todas as fases, de montar letras a ler palavras';

  @override
  String get paywallLoadError => 'Não foi possível carregar os planos';

  @override
  String get paywallNotCompleted => 'O pagamento não foi concluído';

  @override
  String get paywallError => 'Erro no pagamento. Tente novamente em instantes';

  @override
  String get paywallProcessing => 'Processando…';

  @override
  String paywallStartTrial(int days) {
    return 'Começar teste grátis de $days dias';
  }

  @override
  String get paywallUnlock => 'Desbloquear Premium';

  @override
  String get paywallLifetimeTerms =>
      'Pagamento único · Sem assinatura · Seu para sempre';

  @override
  String paywallTrialTerms(String price) {
    return 'Depois $price, renovação automática · Cancele quando quiser';
  }

  @override
  String paywallRenewTerms(String price) {
    return '$price, renovação automática · Cancele quando quiser';
  }

  @override
  String get paywallDemo => 'Pagamento de demonstração: você não será cobrado';

  @override
  String get paywallHowToCancel => 'Como cancelar';

  @override
  String get planLifetime => 'Vitalício';

  @override
  String get planYearly => 'Anual';

  @override
  String get planMonthly => 'Mensal';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsMusic => 'Música';

  @override
  String get settingsSfx => 'Efeitos sonoros';

  @override
  String get settingsVoice => 'Voz';

  @override
  String get settingsMuteAll => 'Silenciar tudo';

  @override
  String get settingsPremiumActive => 'Premium ativo';

  @override
  String get settingsFreePlan => 'Plano grátis';

  @override
  String settingsBilling(String backend) {
    return 'Cobrança: $backend';
  }

  @override
  String get settingsUnlockAll => 'Desbloqueie todas as fases com o Premium';

  @override
  String get cancelTitle => 'Você pode cancelar quando quiser';

  @override
  String get cancelBody =>
      '· As assinaturas são renovadas automaticamente, a menos que sejam canceladas pelo menos 24 horas antes do fim do período.\n\n· iPhone: Ajustes → Apple ID → Assinaturas → Hangul Bricks → Cancelar\n· Web: use o link no e-mail de recibo da Lemon Squeezy\n\n· Depois de cancelar, o Premium continua ativo até o fim do período pago.\n\n· Se você cancelar durante o teste grátis, não será cobrado.';

  @override
  String get cancelOpenSettings => 'Abrir configurações de assinatura';

  @override
  String cancelStoreNote(String channel) {
    return 'As versões da loja abrem as configurações de assinatura do sistema (canal atual: $channel)';
  }

  @override
  String get privacyWeb =>
      '· Seu progresso e seus erros são salvos apenas neste navegador. Não é preciso ter conta.\n\n· Para a nota de pronúncia, sua voz é enviada ao serviço de fala do navegador (Google no Chrome, Apple no Safari) para ser convertida em texto. Ela nunca chega aos servidores do Hangul Bricks e as gravações não são armazenadas.\n\n· O microfone é usado apenas para a nota de pronúncia. Se você negar o acesso, todo o resto continua funcionando.\n\n· Os pagamentos são processados pela nossa revendedora Lemon Squeezy, e o app nunca vê os dados do seu cartão.';

  @override
  String get privacyApp =>
      '· Seu progresso e seus erros são salvos apenas neste dispositivo. Não é preciso ter conta.\n\n· O áudio de pronúncia é analisado apenas no dispositivo, e as gravações nunca são armazenadas nem enviadas.\n\n· O microfone é usado apenas para a nota de pronúncia. Se você negar o acesso, todo o resto continua funcionando.\n\n· Os pagamentos são feitos por compra dentro do app pela App Store, e o app nunca vê os dados do seu cartão.';

  @override
  String get termsBody =>
      '· O uso do Hangul Bricks é regido pelo EULA padrão da Apple e pelos nossos Termos de Serviço da web.\n\n· Vitalício: pagamento único, sem assinatura e sem renovação.\n\n· O plano mensal é renovado automaticamente pelo mesmo preço, a menos que seja cancelado pelo menos 24 horas antes do fim do período.\n\n· Se você cancelar durante o teste grátis, não será cobrado.';
}
