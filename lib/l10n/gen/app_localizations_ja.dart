// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Hangul Bricks';

  @override
  String get language => '言語';

  @override
  String get languageFollowDevice => '端末の言語';

  @override
  String get commonNext => '次へ';

  @override
  String get commonSkip => 'スキップ';

  @override
  String get commonPlay => 'プレイ';

  @override
  String get commonGo => 'スタート';

  @override
  String get commonBackToMap => 'マップに戻る';

  @override
  String get commonFree => '無料';

  @override
  String get commonRestorePurchase => '購入を復元';

  @override
  String get commonPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get commonTermsOfUse => '利用規約';

  @override
  String get commonManageSubscription => 'サブスクリプションを管理';

  @override
  String get commonReadFullText => '全文を読む';

  @override
  String get commonSummary => '概要';

  @override
  String get commonSubscriptionRestored => 'サブスクリプションを復元しました';

  @override
  String get commonNoSubscription => '復元できるサブスクリプションがありません';

  @override
  String get restoreEmailAction => 'メールで復元';

  @override
  String get restoreEmailBody => '購入時に使ったメールアドレスを入力してください。ワンタイムコードをお送りします。';

  @override
  String get restoreEmailField => 'メールアドレス';

  @override
  String get restoreEmailSend => 'コードを送信';

  @override
  String get restoreEmailSent =>
      'このメールアドレスに購入履歴があれば、コードを送信しました。受信トレイ（と迷惑メールフォルダ）を確認してください。';

  @override
  String get restoreEmailCodeField => 'コード';

  @override
  String get restoreEmailConfirm => '復元する';

  @override
  String get restoreEmailBadCode => 'コードが正しくないか、有効期限が切れています。';

  @override
  String get restoreEmailError => 'エラーが発生しました。もう一度お試しください。';

  @override
  String commonCouldNotOpen(String url) {
    return '$url を開けませんでした';
  }

  @override
  String get onbHookTitle => '大好きな曲を\nその国の文字で読もう';

  @override
  String get onbHookBody => 'ハングルは世界で一番覚えやすい文字。ブロックのように文字を組み合わせるだけです。';

  @override
  String get onbPromiseTitle => '7日間で\nハングルが読める';

  @override
  String get onbPromiseFooter => '遊ぶだけでOK。あとはおまかせ。';

  @override
  String get onbNotifTitle => '1日5分で\n連続記録をキープ';

  @override
  String get onbNotifBody => '夕方にやさしくリマインドしましょうか？（任意です）';

  @override
  String get onbAllowReminders => 'リマインダーを許可';

  @override
  String get onbGetStarted => 'はじめる';

  @override
  String get onbChooseLanguage => '言語を選んでください';

  @override
  String trackerHeader(int day) {
    return '7日間でハングルを読む · DAY $day';
  }

  @override
  String get trackerDay1Title => '子音に出会う';

  @override
  String get trackerDay1Goal => '基本の子音10個を覚える';

  @override
  String get trackerDay2Title => '母音のしくみ';

  @override
  String get trackerDay2Goal => '基本の母音6個＋はじめての音節';

  @override
  String get trackerDay3Title => 'ブロックを組み立てる';

  @override
  String get trackerDay3Goal => '縦の母音と横の母音を組み合わせる';

  @override
  String get trackerDay4Title => 'パッチム（終声）';

  @override
  String get trackerDay4Goal => 'パッチムのある音節';

  @override
  String get trackerDay5Title => 'まぎらわしい音';

  @override
  String get trackerDay5Goal => '濃音と激音';

  @override
  String get trackerDay6Title => '単語を読む';

  @override
  String get trackerDay6Goal => 'はじめての12単語を読む';

  @override
  String get trackerDay7Title => 'スラスラ読める';

  @override
  String get trackerDay7Goal => 'どんな音節も読み上げられる';

  @override
  String get homeLearnTitle => 'ハングルを学ぶ · 한글 배우기';

  @override
  String get homeLearnSubtitle => '全文字から読みのルールまで · 無料レッスン8回';

  @override
  String get homeTalkTitle => 'リアルな韓国語 · 상황별 대화';

  @override
  String get homeTalkSubtitlePremium => 'カフェ、タクシー、韓国ドラマ、ファンイベントなど';

  @override
  String get homeTalkSubtitleFree => '無料の会話3つ · プレミアムでさらに';

  @override
  String get homeExploreTitle => '韓国を探検 · 한국 둘러보기';

  @override
  String get homeExploreSubtitle => '旅行アプリ、歴史、食べたいグルメ';

  @override
  String get homeDailyTitle => 'デイリーチャレンジ';

  @override
  String get homeDailySubtitle => 'ミックスラウンドで連続記録をキープ';

  @override
  String get homeStages => 'ステージ';

  @override
  String get homeCodex => '文字図鑑';

  @override
  String homeCodexCount(int count) {
    return '$count / 67 枚';
  }

  @override
  String get homeReview => 'スマート復習';

  @override
  String get homeReviewUnlimited => '無制限';

  @override
  String homeReviewFreeToday(int used) {
    return '今日の無料分 $used/1';
  }

  @override
  String get homeLeague => '週間リーグ · 青磁';

  @override
  String get homeLeagueYou => 'あなた';

  @override
  String get homeSpeechUnsupported => 'この端末は発音機能に対応していません';

  @override
  String get homeNotSupported => 'この端末には対応していません';

  @override
  String get stageJamoHunt => '字母ハント';

  @override
  String get stageJamoHuntSub => '音を聞いて文字をタップ';

  @override
  String get stageLetterBuilder => '文字ビルダー';

  @override
  String get stageLetterBuilderSub => '文字を組み合わせて音節に';

  @override
  String get stageWordRush => 'ワードラッシュ';

  @override
  String get stageWordRushSub => '単語を読んで絵とマッチ';

  @override
  String get stagePronunciation => '発音';

  @override
  String get stagePronunciationSub => '発音を採点しよう';

  @override
  String get miniJamoTitle => '音を描いた文字';

  @override
  String get miniJamoBody => 'ㄱ は舌がのどをふさぐ形、ㅁ は唇の形。\n韓国語の子音は口の形を描いた絵なんです。';

  @override
  String get miniJamoPrompt => 'タップして音を聞く';

  @override
  String get miniBuilderTitle => 'ハングルはなぜブロックのように積み重なるの？';

  @override
  String get miniBuilderBody => '初声・母音・終声が重なって1つのブロックになります。\n母音の形でレイアウトが決まります。';

  @override
  String get miniBuilderPrompt => 'タップして音節を組み立てる';

  @override
  String get miniWordTitle => '本物の単語を読んでみよう';

  @override
  String get miniWordBody => '組み立てられれば、読めます。\nすばやく読んで、合う絵を選びましょう。';

  @override
  String get miniWordPrompt => 'タップして単語を作る';

  @override
  String get miniSpeakTitle => '声に出して言ってみる？';

  @override
  String get miniSpeakBody => '最後はスピーキング。マイクに向かって話すと、\nどの音がうまく言えたか採点します。';

  @override
  String get miniSpeakPrompt => 'タップしてまず聞く';

  @override
  String get miniSkip => 'スキップ →';

  @override
  String miniStartsIn(int seconds) {
    return '$seconds秒後にスタート';
  }

  @override
  String get miniTapToReplay => 'タップしてもう一度';

  @override
  String get jamoHuntPrompt => 'この音の文字を探そう';

  @override
  String comboActive(int multiplier, int combo) {
    return 'x$multiplier コンボ $combo';
  }

  @override
  String comboIdle(int combo) {
    return 'コンボ $combo';
  }

  @override
  String get builderPrompt => '聞いて音節を組み立てよう';

  @override
  String get slotInitial => '初声';

  @override
  String get slotVowel => '母音';

  @override
  String get slotFinal => '終声';

  @override
  String get wordRushPrompt => '読んで、合う絵を選ぼう';

  @override
  String get pronMicNeeded => 'マイクへのアクセスが必要です';

  @override
  String get pronMicBody =>
      'マイクは採点にのみ使用され、\n録音が保存されることはありません。\nブラウザまたは端末の設定でマイクを許可してください。';

  @override
  String get pronListenThenSay => '聞いてから言ってみよう';

  @override
  String get pronTryAgainNext => 'もう一度 / 次へ';

  @override
  String resultXp(int points) {
    return '+$points XP';
  }

  @override
  String resultBestCombo(int combo) {
    return '最高コンボ $combo';
  }

  @override
  String resultNewCards(int count, String letters) {
    return '新しい図鑑カード：$count · $letters';
  }

  @override
  String get resultToReview => '復習する音';

  @override
  String get resultMissedHint => '間違えた文字はより多く出題されます';

  @override
  String get resultNextLevel => '次のレベル';

  @override
  String get reviewComplete => '復習完了！';

  @override
  String reviewScore(int correct, int total) {
    return '$correct / $total 正解';
  }

  @override
  String get reviewTeaserUsed => '今日の無料復習は使い切りました。\nプレミアムなら復習し放題。';

  @override
  String get reviewUnlockUnlimited => '無制限の復習を解放';

  @override
  String reviewHeader(int n, int total) {
    return 'スマート復習  $n/$total';
  }

  @override
  String get reviewQuestion => 'この音を出す文字はどれ？';

  @override
  String codexTitle(int found, int total) {
    return '文字図鑑  $found/$total';
  }

  @override
  String get codexInitials => '初声の子音';

  @override
  String get codexVowels => '母音';

  @override
  String get codexFinals => '終声の子音';

  @override
  String get codexEmptyHint => '字母ハントで音を当てると、最初のカードが解放されます。';

  @override
  String get codexLocked => 'ロック中';

  @override
  String get codexMastered => '★ マスター';

  @override
  String get codexVelar => '舌の根元がのどをふさぐ形';

  @override
  String get codexAlveolar => '舌先が歯ぐきにつく形';

  @override
  String get codexLabial => '唇の形';

  @override
  String get codexDental => '歯の形';

  @override
  String get codexGlottal => 'のどの形';

  @override
  String codexCheonjiin(String parts) {
    return '天（ㆍ）・地（ㅡ）・人（ㅣ）から作られています：$parts';
  }

  @override
  String get codexFinalSound => '終声のときの音';

  @override
  String get codexHearIt => '聞いてみる';

  @override
  String get learnTitle => 'ハングルを学ぶ · 한글 배우기';

  @override
  String get learnIntro => '韓国語を読むために必要なすべてを、8つの短いレッスンで。';

  @override
  String learnNext(String title) {
    return '次：$title';
  }

  @override
  String get learnBackToLessons => 'レッスン一覧に戻る';

  @override
  String get learnLayoutTall => '縦の母音：子音が左、母音が右';

  @override
  String get learnLayoutFlat => '横の母音：子音が上、母音が下';

  @override
  String get learnLayoutMixed => '複合母音：下と右を囲む';

  @override
  String get learnPickInitial => '1. 最初の子音';

  @override
  String get learnPickVowel => '2. 母音';

  @override
  String get learnPickFinal => '3. 終声の子音（任意）';

  @override
  String learnExample(String words) {
    return '例：$words';
  }

  @override
  String get talkTitle => 'リアルな韓国語 · 상황별 대화';

  @override
  String get talkIntro => '実際に出会う場面で使えるフレーズ。どの行もタップすると音声が聞けます。';

  @override
  String get talkRomanization => 'ローマ字表記';

  @override
  String get talkKeyPhrases => 'キーフレーズ';

  @override
  String get talkCultureTip => 'カルチャーTIP';

  @override
  String get exploreTitle => '韓国を探検 · 한국 둘러보기';

  @override
  String get exploreTabApps => 'アプリ';

  @override
  String get exploreTabHistory => '歴史';

  @override
  String get exploreTabFood => 'グルメ';

  @override
  String get exploreTabSaju => '四柱推命';

  @override
  String get exploreAppsIntro => '出発前にインストールしておけば、韓国旅行がぐっとラクに。';

  @override
  String exploreTip(String tip) {
    return 'TIP：$tip';
  }

  @override
  String get exploreHistoryIntro => '5,000年の歴史を11のスポットで。';

  @override
  String get exploreFoodIntro =>
      '絶対食べたい料理。マップボタンをタップすると、今いる場所の近くで評価の高いお店が見られます。リアルタイムの評価なので、情報が古くなりません。';

  @override
  String get exploreNaverEnglish =>
      'Naver Map を英語で使うには：アプリで MY → 設定 → 言語 → English を選択。';

  @override
  String exploreWhere(String place) {
    return '場所：$place';
  }

  @override
  String get exploreSajuIntro =>
      'サジュ（사주）は、生まれた年・月・日・時の「四柱」から運勢を読む韓国の占いです。カップルは大事な決断の前に相性（궁합）を占います。';

  @override
  String get exploreViewOnEtsy => 'Etsy で見る';

  @override
  String get paywallTitle => 'ハングルを最後まで読めるように';

  @override
  String get paywallPronWeb => '発音の採点（Chrome & Safari）';

  @override
  String get paywallReviewWeb => '間違えた音を無制限にスマート復習';

  @override
  String get paywallStagesWeb => '文字ビルダー全レベル＋ワードラッシュ';

  @override
  String get paywallStreakWeb => '連続記録を守るストリーク修復';

  @override
  String get paywallPronApp => 'すべての文字の発音を採点';

  @override
  String get paywallReviewApp => '間違えた音をスマート復習';

  @override
  String get paywallStagesApp => '文字の組み立てから単語の読みまで、全ステージ';

  @override
  String get paywallLoadError => 'プランを読み込めませんでした';

  @override
  String get paywallNotCompleted => '支払いが完了しませんでした';

  @override
  String get paywallError => '支払いエラーが発生しました。しばらくしてからもう一度お試しください';

  @override
  String get paywallProcessing => '処理中…';

  @override
  String paywallStartTrial(int days) {
    return '$days日間の無料トライアルを開始';
  }

  @override
  String get paywallUnlock => 'プレミアムを解放';

  @override
  String get paywallLifetimeTerms => '1回払い · サブスクリプションなし · ずっと使えます';

  @override
  String paywallTrialTerms(String price) {
    return 'その後 $price、自動更新 · いつでも解約可能';
  }

  @override
  String paywallRenewTerms(String price) {
    return '$price、自動更新 · いつでも解約可能';
  }

  @override
  String get paywallDemo => 'デモ決済：料金は請求されません';

  @override
  String get paywallHowToCancel => '解約方法';

  @override
  String get planLifetime => '買い切り';

  @override
  String get planYearly => '年額';

  @override
  String get planMonthly => '月額';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsMusic => '音楽';

  @override
  String get settingsSfx => '効果音';

  @override
  String get settingsVoice => '音声';

  @override
  String get settingsMuteAll => 'すべてミュート';

  @override
  String get settingsPremiumActive => 'プレミアム有効';

  @override
  String get settingsFreePlan => '無料プラン';

  @override
  String settingsBilling(String backend) {
    return '決済：$backend';
  }

  @override
  String get settingsUnlockAll => 'プレミアムで全ステージを解放';

  @override
  String get cancelTitle => 'いつでも解約できます';

  @override
  String get cancelBody =>
      '· サブスクリプションは、期間終了の24時間以上前までに解約しない限り自動的に更新されます。\n\n· iPhone：設定 → Apple ID → サブスクリプション → Hangul Bricks → キャンセル\n· Web：Lemon Squeezy の領収書メールにあるリンクから解約できます\n\n· 解約後も、支払い済みの期間が終わるまでプレミアムは有効です。\n\n· 無料トライアル期間中に解約すれば、料金は請求されません。';

  @override
  String get cancelOpenSettings => 'サブスクリプション設定を開く';

  @override
  String cancelStoreNote(String channel) {
    return 'ストア版ではOSのサブスクリプション設定が開きます（現在のチャネル：$channel）';
  }

  @override
  String get privacyWeb =>
      '· 学習の進み具合や間違いは、このブラウザ内にのみ保存されます。アカウントは不要です。\n\n· 発音の採点では、音声をテキストに変換するためにブラウザの音声認識サービス（Chrome では Google、Safari では Apple）に送信されます。Hangul Bricks のサーバーに届くことはなく、録音も保存されません。\n\n· マイクは発音の採点にのみ使用されます。許可しなくても、その他の機能はすべて使えます。\n\n· 支払いは販売代理店の Lemon Squeezy が処理し、アプリがカード情報を見ることはありません。\n\n· 「メールで復元」を使うと、入力したメールアドレスは Lemon Squeezy で購入履歴を確認するために Hangul Bricks のサーバーへ送信され、ワンタイムコードはメール配信サービス Resend を通じて届きます。メールアドレスは保存されません。';

  @override
  String get privacyApp =>
      '· 学習の進み具合や間違いは、この端末にのみ保存されます。アカウントは不要です。\n\n· 発音の音声は端末上でのみ分析され、録音が保存・アップロードされることはありません。\n\n· マイクは発音の採点にのみ使用されます。許可しなくても、その他の機能はすべて使えます。\n\n· 支払いは App Store のアプリ内課金で行われ、アプリがカード情報を見ることはありません。';

  @override
  String get termsBody =>
      '· Hangul Bricks のご利用には、Apple の標準 EULA および当社の Web 利用規約が適用されます。\n\n· 買い切り：1回払い。サブスクリプションも更新もありません。\n\n· 月額プランは、期間終了の24時間以上前までに解約しない限り、同じ価格で自動的に更新されます。\n\n· 無料トライアル期間中に解約すれば、料金は請求されません。';
}
