// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class L10nZh extends L10n {
  L10nZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Hangul Bricks';

  @override
  String get language => '语言';

  @override
  String get languageFollowDevice => '跟随设备语言';

  @override
  String get commonNext => '下一步';

  @override
  String get commonSkip => '跳过';

  @override
  String get commonPlay => '开始玩';

  @override
  String get commonGo => '出发';

  @override
  String get commonBackToMap => '返回地图';

  @override
  String get commonFree => '免费';

  @override
  String get commonRestorePurchase => '恢复购买';

  @override
  String get commonPrivacyPolicy => '隐私政策';

  @override
  String get commonTermsOfUse => '使用条款';

  @override
  String get commonManageSubscription => '管理订阅';

  @override
  String get commonReadFullText => '阅读全文';

  @override
  String get commonSummary => '摘要';

  @override
  String get commonSubscriptionRestored => '订阅已恢复';

  @override
  String get commonNoSubscription => '没有可恢复的订阅';

  @override
  String get restoreEmailAction => '通过邮箱恢复';

  @override
  String get restoreEmailBody => '请输入付款时使用的邮箱，我们会发送一次性验证码。';

  @override
  String get restoreEmailField => '邮箱';

  @override
  String get restoreEmailSend => '发送验证码';

  @override
  String get restoreEmailSent => '如果该邮箱有购买记录，验证码已在路上。请查看收件箱（和垃圾邮件）。';

  @override
  String get restoreEmailCodeField => '验证码';

  @override
  String get restoreEmailConfirm => '恢复';

  @override
  String get restoreEmailBadCode => '验证码错误或已过期。';

  @override
  String get restoreEmailError => '出错了，请重试。';

  @override
  String commonCouldNotOpen(String url) {
    return '无法打开 $url';
  }

  @override
  String get onbHookTitle => '用原文字母\n读懂你喜欢的歌';

  @override
  String get onbHookBody => '韩文是世界上最容易学的文字——字母像积木一样拼在一起。';

  @override
  String get onbPromiseTitle => '7天\n读懂韩文';

  @override
  String get onbPromiseFooter => '只管玩，其余交给我们。';

  @override
  String get onbNotifTitle => '每天5分钟\n保持连续打卡';

  @override
  String get onbNotifBody => '需要每晚温馨提醒吗？可选。';

  @override
  String get onbAllowReminders => '允许提醒';

  @override
  String get onbGetStarted => '开始';

  @override
  String get onbChooseLanguage => '选择语言';

  @override
  String trackerHeader(int day) {
    return '7天读懂韩文 · 第$day天';
  }

  @override
  String get trackerDay1Title => '认识辅音';

  @override
  String get trackerDay1Goal => '认出10个基本辅音';

  @override
  String get trackerDay2Title => '元音的规则';

  @override
  String get trackerDay2Goal => '6个基本元音＋你的第一个音节';

  @override
  String get trackerDay3Title => '搭建积木';

  @override
  String get trackerDay3Goal => '组合竖元音和横元音';

  @override
  String get trackerDay4Title => '收音（韵尾）';

  @override
  String get trackerDay4Goal => '带收音的音节';

  @override
  String get trackerDay5Title => '易混的发音';

  @override
  String get trackerDay5Goal => '紧音与送气音';

  @override
  String get trackerDay6Title => '读单词';

  @override
  String get trackerDay6Goal => '读出你的前12个单词';

  @override
  String get trackerDay7Title => '流利阅读';

  @override
  String get trackerDay7Goal => '任何音节都能拼读';

  @override
  String get homeLearnTitle => '学韩文 · 한글 배우기';

  @override
  String get homeLearnSubtitle => '从全部字母到拼读规则 · 8节免费课程';

  @override
  String get homeTalkTitle => '实用韩语 · 상황별 대화';

  @override
  String get homeTalkSubtitlePremium => '咖啡馆、出租车、韩剧、粉丝活动等';

  @override
  String get homeTalkSubtitleFree => '3段免费对话 · 高级版解锁更多';

  @override
  String get homeExploreTitle => '探索韩国 · 한국 둘러보기';

  @override
  String get homeExploreSubtitle => '旅行App、历史和必吃美食';

  @override
  String get homeDailyTitle => '每日挑战';

  @override
  String get homeDailySubtitle => '来一轮混合练习，保持连续打卡';

  @override
  String get homeStages => '关卡';

  @override
  String get homeCodex => '字母图鉴';

  @override
  String homeCodexCount(int count) {
    return '$count / 67 张卡';
  }

  @override
  String get homeReview => '智能复习';

  @override
  String get homeReviewUnlimited => '无限次';

  @override
  String homeReviewFreeToday(int used) {
    return '今日免费 $used/1';
  }

  @override
  String get homeLeague => '每周联赛 · 青瓷';

  @override
  String get homeLeagueYou => '你';

  @override
  String get homeSpeechUnsupported => '此设备不支持发音功能';

  @override
  String get homeNotSupported => '此设备不支持';

  @override
  String get stageJamoHunt => '字母猎人';

  @override
  String get stageJamoHuntSub => '听声音，点字母';

  @override
  String get stageLetterBuilder => '拼字工坊';

  @override
  String get stageLetterBuilderSub => '把字母拼成音节';

  @override
  String get stageWordRush => '单词冲刺';

  @override
  String get stageWordRushSub => '读单词，配图片';

  @override
  String get stagePronunciation => '发音';

  @override
  String get stagePronunciationSub => '为你的发音打分';

  @override
  String get miniJamoTitle => '描绘声音的字母';

  @override
  String get miniJamoBody => 'ㄱ 是舌根挡住喉咙的样子，ㅁ 是嘴唇的样子。\n韩文辅音就是口腔的图画。';

  @override
  String get miniJamoPrompt => '点击听发音';

  @override
  String get miniBuilderTitle => '韩文为什么像积木一样叠起来？';

  @override
  String get miniBuilderBody => '初声、元音和收音叠成一个方块。\n元音的形状决定了排列方式。';

  @override
  String get miniBuilderPrompt => '点击拼出音节';

  @override
  String get miniWordTitle => '现在来读真正的单词';

  @override
  String get miniWordBody => '能拼出来，就能读出来。\n快速阅读，选出对应的图片。';

  @override
  String get miniWordPrompt => '点击组成单词';

  @override
  String get miniSpeakTitle => '准备好大声说出来了吗？';

  @override
  String get miniSpeakBody => '最后是口语。对着麦克风说，\n我们会为你说准的音打分。';

  @override
  String get miniSpeakPrompt => '点击先听一遍';

  @override
  String get miniSkip => '跳过 →';

  @override
  String miniStartsIn(int seconds) {
    return '$seconds秒后开始';
  }

  @override
  String get miniTapToReplay => '点击重播';

  @override
  String get jamoHuntPrompt => '找出这个发音对应的字母';

  @override
  String comboActive(int multiplier, int combo) {
    return 'x$multiplier 连击 $combo';
  }

  @override
  String comboIdle(int combo) {
    return '连击 $combo';
  }

  @override
  String get builderPrompt => '听一听，拼出音节';

  @override
  String get slotInitial => '初声';

  @override
  String get slotVowel => '元音';

  @override
  String get slotFinal => '收音';

  @override
  String get wordRushPrompt => '读一读，选出对应的图片';

  @override
  String get pronMicNeeded => '需要麦克风权限';

  @override
  String get pronMicBody => '麦克风仅用于打分，\n录音绝不会被保存。\n请在浏览器或设备设置中允许使用麦克风。';

  @override
  String get pronListenThenSay => '先听，再说';

  @override
  String get pronTryAgainNext => '再试一次 / 下一个';

  @override
  String resultXp(int points) {
    return '+$points XP';
  }

  @override
  String resultBestCombo(int combo) {
    return '最高连击 $combo';
  }

  @override
  String resultNewCards(int count, String letters) {
    return '新图鉴卡：$count · $letters';
  }

  @override
  String get resultToReview => '需要复习的发音';

  @override
  String get resultMissedHint => '答错的字母会更常出现';

  @override
  String get resultNextLevel => '下一关';

  @override
  String get reviewComplete => '复习完成！';

  @override
  String reviewScore(int correct, int total) {
    return '答对 $correct / $total';
  }

  @override
  String get reviewTeaserUsed => '今天的免费复习已用完。\n高级版可无限次复习。';

  @override
  String get reviewUnlockUnlimited => '解锁无限复习';

  @override
  String reviewHeader(int n, int total) {
    return '智能复习  $n/$total';
  }

  @override
  String get reviewQuestion => '哪个字母发这个音？';

  @override
  String codexTitle(int found, int total) {
    return '字母图鉴  $found/$total';
  }

  @override
  String get codexInitials => '初声辅音';

  @override
  String get codexVowels => '元音';

  @override
  String get codexFinals => '收音辅音';

  @override
  String get codexEmptyHint => '在字母猎人中答对一个发音，即可解锁你的第一张卡。';

  @override
  String get codexLocked => '未解锁';

  @override
  String get codexMastered => '★ 已掌握';

  @override
  String get codexVelar => '形似舌根挡住喉咙';

  @override
  String get codexAlveolar => '形似舌尖抵住齿龈';

  @override
  String get codexLabial => '形似嘴唇';

  @override
  String get codexDental => '形似牙齿';

  @override
  String get codexGlottal => '形似喉咙';

  @override
  String codexCheonjiin(String parts) {
    return '由天（ㆍ）、地（ㅡ）、人（ㅣ）组成：$parts';
  }

  @override
  String get codexFinalSound => '作为收音时的发音';

  @override
  String get codexHearIt => '听一听';

  @override
  String get learnTitle => '学韩文 · 한글 배우기';

  @override
  String get learnIntro => '读懂韩文所需的一切，尽在8节简短课程中。';

  @override
  String learnNext(String title) {
    return '下一课：$title';
  }

  @override
  String get learnBackToLessons => '返回课程列表';

  @override
  String get learnLayoutTall => '竖元音：辅音在左，元音在右';

  @override
  String get learnLayoutFlat => '横元音：辅音在上，元音在下';

  @override
  String get learnLayoutMixed => '复合元音：从下方和右侧包围';

  @override
  String get learnPickInitial => '1. 第一个辅音';

  @override
  String get learnPickVowel => '2. 元音';

  @override
  String get learnPickFinal => '3. 收音辅音（可选）';

  @override
  String learnExample(String words) {
    return '例：$words';
  }

  @override
  String get talkTitle => '实用韩语 · 상황별 대화';

  @override
  String get talkIntro => '真正会遇到的场景用语——点击任意一句即可收听。';

  @override
  String get talkRomanization => '罗马字注音';

  @override
  String get talkKeyPhrases => '重点句型';

  @override
  String get talkCultureTip => '文化小贴士';

  @override
  String get exploreTitle => '探索韩国 · 한국 둘러보기';

  @override
  String get exploreTabApps => 'App';

  @override
  String get exploreTabHistory => '历史';

  @override
  String get exploreTabFood => '美食';

  @override
  String get exploreTabSaju => '四柱';

  @override
  String get exploreAppsIntro => '出发前装好这些App，玩转韩国更轻松。';

  @override
  String exploreTip(String tip) {
    return '小贴士：$tip';
  }

  @override
  String get exploreHistoryIntro => '11站带你走过5000年。';

  @override
  String get exploreFoodIntro => '必吃美食。点击地图按钮，即可查看你附近当前评分最高的店铺——实时评分，永不过时。';

  @override
  String get exploreNaverEnglish =>
      'Naver Map 切换英文：在App中进入 MY → 设置 → 语言 → English。';

  @override
  String exploreWhere(String place) {
    return '地点：$place';
  }

  @override
  String get exploreSajuIntro =>
      '四柱（사주）是根据出生年、月、日、时这“四柱”来算命的韩国传统占卜。情侣在做重大决定前会先合一合八字——궁합。';

  @override
  String get exploreViewOnEtsy => '在 Etsy 上查看';

  @override
  String get paywallTitle => '彻底读懂韩文';

  @override
  String get paywallPronWeb => '发音打分（Chrome 和 Safari）';

  @override
  String get paywallReviewWeb => '无限次智能复习你答错的发音';

  @override
  String get paywallStagesWeb => '拼字工坊全部关卡＋单词冲刺';

  @override
  String get paywallStreakWeb => '打卡修复，守护你的连续记录';

  @override
  String get paywallPronApp => '每个字母的发音打分';

  @override
  String get paywallReviewApp => '智能复习你答错的发音';

  @override
  String get paywallStagesApp => '从拼字母到读单词，全部关卡';

  @override
  String get paywallLoadError => '无法加载方案';

  @override
  String get paywallNotCompleted => '付款未完成';

  @override
  String get paywallError => '付款出错，请稍后再试';

  @override
  String get paywallProcessing => '处理中…';

  @override
  String paywallStartTrial(int days) {
    return '开始$days天免费试用';
  }

  @override
  String get paywallUnlock => '解锁高级版';

  @override
  String get paywallLifetimeTerms => '一次性付款 · 非订阅 · 永久拥有';

  @override
  String paywallTrialTerms(String price) {
    return '之后 $price，自动续订 · 可随时取消';
  }

  @override
  String paywallRenewTerms(String price) {
    return '$price，自动续订 · 可随时取消';
  }

  @override
  String get paywallDemo => '演示结账：不会向你收费';

  @override
  String get paywallHowToCancel => '如何取消';

  @override
  String get planLifetime => '终身';

  @override
  String get planYearly => '按年';

  @override
  String get planMonthly => '按月';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsMusic => '音乐';

  @override
  String get settingsSfx => '音效';

  @override
  String get settingsVoice => '语音';

  @override
  String get settingsMuteAll => '全部静音';

  @override
  String get settingsPremiumActive => '高级版已激活';

  @override
  String get settingsFreePlan => '免费版';

  @override
  String settingsBilling(String backend) {
    return '支付方式：$backend';
  }

  @override
  String get settingsUnlockAll => '用高级版解锁全部关卡';

  @override
  String get cancelTitle => '可随时取消';

  @override
  String get cancelBody =>
      '· 除非在当前周期结束前至少24小时取消，否则订阅将自动续订。\n\n· iPhone：设置 → Apple ID → 订阅 → Hangul Bricks → 取消\n· 网页版：使用 Lemon Squeezy 收据邮件中的链接取消\n\n· 取消后，高级版在已付费周期结束前仍然有效。\n\n· 在免费试用期内取消，不会产生任何费用。';

  @override
  String get cancelOpenSettings => '打开订阅设置';

  @override
  String cancelStoreNote(String channel) {
    return '商店版将打开系统的订阅设置（当前渠道：$channel）';
  }

  @override
  String get privacyWeb =>
      '· 你的学习进度和错题只保存在此浏览器中，无需注册账号。\n\n· 进行发音打分时，你的语音会被发送到浏览器的语音服务（Chrome 使用 Google，Safari 使用 Apple）转换为文字。语音绝不会到达 Hangul Bricks 的服务器，录音也不会被保存。\n\n· 麦克风仅用于发音打分。即使拒绝授权，其他功能也都能正常使用。\n\n· 付款由我们的经销商 Lemon Squeezy 处理，App 绝不会接触你的银行卡信息。';

  @override
  String get privacyApp =>
      '· 你的学习进度和错题只保存在此设备上，无需注册账号。\n\n· 发音音频仅在设备本地分析，录音绝不会被保存或上传。\n\n· 麦克风仅用于发音打分。即使拒绝授权，其他功能也都能正常使用。\n\n· 付款通过 App Store 的 App 内购买完成，App 绝不会接触你的银行卡信息。';

  @override
  String get termsBody =>
      '· 使用 Hangul Bricks 须遵守 Apple 标准 EULA 及我们的网页版服务条款。\n\n· 终身版：一次性付款——非订阅，不会续费。\n\n· 除非在当前周期结束前至少24小时取消，否则月度方案将按相同价格自动续订。\n\n· 在免费试用期内取消，不会产生任何费用。';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class L10nZhTw extends L10nZh {
  L10nZhTw() : super('zh_TW');

  @override
  String get appName => 'Hangul Bricks';

  @override
  String get language => '語言';

  @override
  String get languageFollowDevice => '裝置語言';

  @override
  String get commonNext => '下一步';

  @override
  String get commonSkip => '略過';

  @override
  String get commonPlay => '開始';

  @override
  String get commonGo => '出發';

  @override
  String get commonBackToMap => '回到地圖';

  @override
  String get commonFree => '免費';

  @override
  String get commonRestorePurchase => '恢復購買';

  @override
  String get commonPrivacyPolicy => '隱私權政策';

  @override
  String get commonTermsOfUse => '使用條款';

  @override
  String get commonManageSubscription => '管理訂閱';

  @override
  String get commonReadFullText => '閱讀全文';

  @override
  String get commonSummary => '摘要';

  @override
  String get commonSubscriptionRestored => '已恢復訂閱';

  @override
  String get commonNoSubscription => '沒有可恢復的訂閱';

  @override
  String get restoreEmailAction => '透過電子郵件恢復';

  @override
  String get restoreEmailBody => '請輸入付款時使用的電子郵件，我們會寄送一次性驗證碼。';

  @override
  String get restoreEmailField => '電子郵件';

  @override
  String get restoreEmailSend => '寄送驗證碼';

  @override
  String get restoreEmailSent => '如果此電子郵件有購買紀錄，驗證碼已寄出。請查看收件匣（和垃圾郵件）。';

  @override
  String get restoreEmailCodeField => '驗證碼';

  @override
  String get restoreEmailConfirm => '恢復';

  @override
  String get restoreEmailBadCode => '驗證碼錯誤或已過期。';

  @override
  String get restoreEmailError => '發生錯誤，請再試一次。';

  @override
  String commonCouldNotOpen(String url) {
    return '無法開啟 $url';
  }

  @override
  String get onbHookTitle => '用原文字母\n讀懂你喜愛的歌';

  @override
  String get onbHookBody => '韓文字是世界上最容易學的文字——字母像積木一樣拼在一起。';

  @override
  String get onbPromiseTitle => '7 天\n學會讀韓文';

  @override
  String get onbPromiseFooter => '只要玩就好，其他交給我們。';

  @override
  String get onbNotifTitle => '每天 5 分鐘\n維持連續紀錄';

  @override
  String get onbNotifBody => '想在晚上收到溫柔的提醒嗎？可自由選擇。';

  @override
  String get onbAllowReminders => '允許提醒';

  @override
  String get onbGetStarted => '開始使用';

  @override
  String get onbChooseLanguage => '選擇你的語言';

  @override
  String trackerHeader(int day) {
    return '7 天學會讀韓文 · 第 $day 天';
  }

  @override
  String get trackerDay1Title => '認識子音';

  @override
  String get trackerDay1Goal => '認得 10 個基本子音';

  @override
  String get trackerDay2Title => '母音怎麼用';

  @override
  String get trackerDay2Goal => '6 個基本母音＋你的第一個音節';

  @override
  String get trackerDay3Title => '拼字積木';

  @override
  String get trackerDay3Goal => '組合直式與橫式母音';

  @override
  String get trackerDay4Title => '收尾子音';

  @override
  String get trackerDay4Goal => '有收尾音（batchim）的音節';

  @override
  String get trackerDay5Title => '難分的發音';

  @override
  String get trackerDay5Goal => '緊音與送氣音';

  @override
  String get trackerDay6Title => '讀單字';

  @override
  String get trackerDay6Goal => '讀出你的前 12 個單字';

  @override
  String get trackerDay7Title => '流利閱讀';

  @override
  String get trackerDay7Goal => '任何音節都能唸出來';

  @override
  String get homeLearnTitle => '學韓文字 · 한글 배우기';

  @override
  String get homeLearnSubtitle => '從每個字母到發音規則 · 8 堂免費課程';

  @override
  String get homeTalkTitle => '生活韓語 · 상황별 대화';

  @override
  String get homeTalkSubtitlePremium => '咖啡廳、計程車、韓劇、粉絲活動等';

  @override
  String get homeTalkSubtitleFree => '3 段免費對話 · Premium 解鎖更多';

  @override
  String get homeExploreTitle => '探索韓國 · 한국 둘러보기';

  @override
  String get homeExploreSubtitle => '旅遊 App、歷史與必吃美食';

  @override
  String get homeDailyTitle => '每日挑戰';

  @override
  String get homeDailySubtitle => '玩一回綜合關卡，維持連續紀錄';

  @override
  String get homeStages => '關卡';

  @override
  String get homeCodex => '字母圖鑑';

  @override
  String homeCodexCount(int count) {
    return '$count / 67 張卡';
  }

  @override
  String get homeReview => '智慧複習';

  @override
  String get homeReviewUnlimited => '無限次';

  @override
  String homeReviewFreeToday(int used) {
    return '今日免費 $used/1';
  }

  @override
  String get homeLeague => '每週聯賽 · 青瓷';

  @override
  String get homeLeagueYou => '你';

  @override
  String get homeSpeechUnsupported => '此裝置不支援發音功能';

  @override
  String get homeNotSupported => '此裝置不支援';

  @override
  String get stageJamoHunt => '字母獵人';

  @override
  String get stageJamoHuntSub => '聽聲音，點出字母';

  @override
  String get stageLetterBuilder => '字母拼拼樂';

  @override
  String get stageLetterBuilderSub => '把字母拼成音節';

  @override
  String get stageWordRush => '單字衝刺';

  @override
  String get stageWordRushSub => '讀單字，配對圖片';

  @override
  String get stagePronunciation => '發音練習';

  @override
  String get stagePronunciationSub => '幫你的發音打分數';

  @override
  String get miniJamoTitle => '畫出聲音的字母';

  @override
  String get miniJamoBody => 'ㄱ 畫的是舌頭擋住喉嚨，ㅁ 畫的是嘴唇。\n韓文子音就是嘴巴的圖畫。';

  @override
  String get miniJamoPrompt => '點一下聽發音';

  @override
  String get miniBuilderTitle => '韓文字為什麼像積木一樣疊起來？';

  @override
  String get miniBuilderBody => '初聲、母音和收尾音疊成一個方塊。\n母音的形狀決定排列方式。';

  @override
  String get miniBuilderPrompt => '點一下拼出音節';

  @override
  String get miniWordTitle => '現在來讀真正的單字';

  @override
  String get miniWordBody => '拼得出來，就讀得出來。\n快速閱讀，選出對應的圖片。';

  @override
  String get miniWordPrompt => '點一下組成單字';

  @override
  String get miniSpeakTitle => '準備好大聲說出來了嗎？';

  @override
  String get miniSpeakBody => '最後是開口說。對著麥克風唸，\n我們會評分哪些音你唸得完美。';

  @override
  String get miniSpeakPrompt => '點一下先聽聽看';

  @override
  String get miniSkip => '略過 →';

  @override
  String miniStartsIn(int seconds) {
    return '$seconds 秒後開始';
  }

  @override
  String get miniTapToReplay => '點一下重播';

  @override
  String get jamoHuntPrompt => '找出這個聲音的字母';

  @override
  String comboActive(int multiplier, int combo) {
    return 'x$multiplier 連擊 $combo';
  }

  @override
  String comboIdle(int combo) {
    return '連擊 $combo';
  }

  @override
  String get builderPrompt => '聽一聽，拼出音節';

  @override
  String get slotInitial => '初聲';

  @override
  String get slotVowel => '母音';

  @override
  String get slotFinal => '收尾音';

  @override
  String get wordRushPrompt => '讀一讀，選出對應的圖片';

  @override
  String get pronMicNeeded => '需要麥克風權限';

  @override
  String get pronMicBody => '麥克風僅用於評分，\n錄音絕不會被儲存。\n請在瀏覽器或裝置設定中允許使用麥克風。';

  @override
  String get pronListenThenSay => '先聽，再說';

  @override
  String get pronTryAgainNext => '再試一次 / 下一個';

  @override
  String resultXp(int points) {
    return '+$points XP';
  }

  @override
  String resultBestCombo(int combo) {
    return '最高連擊 $combo';
  }

  @override
  String resultNewCards(int count, String letters) {
    return '新圖鑑卡：$count 張 · $letters';
  }

  @override
  String get resultToReview => '需要複習的發音';

  @override
  String get resultMissedHint => '答錯的字母會更常出現';

  @override
  String get resultNextLevel => '下一關';

  @override
  String get reviewComplete => '複習完成！';

  @override
  String reviewScore(int correct, int total) {
    return '答對 $correct / $total';
  }

  @override
  String get reviewTeaserUsed => '今天的免費複習已用完。\nPremium 可無限次複習。';

  @override
  String get reviewUnlockUnlimited => '解鎖無限次複習';

  @override
  String reviewHeader(int n, int total) {
    return '智慧複習  $n/$total';
  }

  @override
  String get reviewQuestion => '哪個字母發這個音？';

  @override
  String codexTitle(int found, int total) {
    return '字母圖鑑  $found/$total';
  }

  @override
  String get codexInitials => '初聲子音';

  @override
  String get codexVowels => '母音';

  @override
  String get codexFinals => '收尾子音';

  @override
  String get codexEmptyHint => '在字母獵人中答對一個音，就能解鎖第一張卡。';

  @override
  String get codexLocked => '未解鎖';

  @override
  String get codexMastered => '★ 已精通';

  @override
  String get codexVelar => '形狀像舌根擋住喉嚨';

  @override
  String get codexAlveolar => '形狀像舌尖碰到上齒齦';

  @override
  String get codexLabial => '形狀像嘴唇';

  @override
  String get codexDental => '形狀像牙齒';

  @override
  String get codexGlottal => '形狀像喉嚨';

  @override
  String codexCheonjiin(String parts) {
    return '由天（ㆍ）、地（ㅡ）、人（ㅣ）組成：$parts';
  }

  @override
  String get codexFinalSound => '作為收尾子音時的發音';

  @override
  String get codexHearIt => '聽發音';

  @override
  String get learnTitle => '學韓文字 · 한글 배우기';

  @override
  String get learnIntro => '讀懂韓文需要的一切，濃縮在 8 堂短課裡。';

  @override
  String learnNext(String title) {
    return '下一課：$title';
  }

  @override
  String get learnBackToLessons => '回到課程列表';

  @override
  String get learnLayoutTall => '直式母音：子音在左，母音在右';

  @override
  String get learnLayoutFlat => '橫式母音：子音在上，母音在下';

  @override
  String get learnLayoutMixed => '複合母音：包在下方與右方';

  @override
  String get learnPickInitial => '1. 初聲子音';

  @override
  String get learnPickVowel => '2. 母音';

  @override
  String get learnPickFinal => '3. 收尾子音（可選）';

  @override
  String learnExample(String words) {
    return '例：$words';
  }

  @override
  String get talkTitle => '生活韓語 · 상황별 대화';

  @override
  String get talkIntro => '真正會遇到的情境用語——點任何一句就能聽發音。';

  @override
  String get talkRomanization => '羅馬拼音';

  @override
  String get talkKeyPhrases => '重點句型';

  @override
  String get talkCultureTip => '文化小知識';

  @override
  String get exploreTitle => '探索韓國 · 한국 둘러보기';

  @override
  String get exploreTabApps => 'App';

  @override
  String get exploreTabHistory => '歷史';

  @override
  String get exploreTabFood => '美食';

  @override
  String get exploreTabSaju => '四柱';

  @override
  String get exploreAppsIntro => '出發前先安裝這些——韓國旅行輕鬆多了。';

  @override
  String exploreTip(String tip) {
    return '小提示：$tip';
  }

  @override
  String get exploreHistoryIntro => '5,000 年歷史，11 個站點。';

  @override
  String get exploreFoodIntro => '必吃料理。點地圖按鈕，立即查看你附近評價最高的店家——即時評分，永不過時。';

  @override
  String get exploreNaverEnglish =>
      'Naver Map 英文版：在 App 中前往 MY → 設定 → 語言 → English。';

  @override
  String exploreWhere(String place) {
    return '地點：$place';
  }

  @override
  String get exploreSajuIntro =>
      '四柱（사주）是根據出生年、月、日、時這「四柱」來算命的韓國傳統。情侶在做重大決定前會先看彼此的合婚——궁합。';

  @override
  String get exploreViewOnEtsy => '在 Etsy 上查看';

  @override
  String get paywallTitle => '完整學會讀韓文';

  @override
  String get paywallPronWeb => '發音評分（Chrome 與 Safari）';

  @override
  String get paywallReviewWeb => '針對答錯的發音無限次智慧複習';

  @override
  String get paywallStagesWeb => '所有字母拼拼樂關卡＋單字衝刺';

  @override
  String get paywallStreakWeb => '連續紀錄修復，守護你的紀錄';

  @override
  String get paywallPronApp => '每個字母都能發音評分';

  @override
  String get paywallReviewApp => '針對答錯的發音進行智慧複習';

  @override
  String get paywallStagesApp => '所有關卡，從拼字母到讀單字';

  @override
  String get paywallLoadError => '無法載入方案';

  @override
  String get paywallNotCompleted => '付款未完成';

  @override
  String get paywallError => '付款發生錯誤，請稍後再試';

  @override
  String get paywallProcessing => '處理中…';

  @override
  String paywallStartTrial(int days) {
    return '開始 $days 天免費試用';
  }

  @override
  String get paywallUnlock => '解鎖 Premium';

  @override
  String get paywallLifetimeTerms => '一次付費 · 非訂閱制 · 永久擁有';

  @override
  String paywallTrialTerms(String price) {
    return '試用後 $price，自動續訂 · 可隨時取消';
  }

  @override
  String paywallRenewTerms(String price) {
    return '$price，自動續訂 · 可隨時取消';
  }

  @override
  String get paywallDemo => '示範結帳：不會向你收費';

  @override
  String get paywallHowToCancel => '如何取消';

  @override
  String get planLifetime => '終身';

  @override
  String get planYearly => '年繳';

  @override
  String get planMonthly => '月繳';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsMusic => '音樂';

  @override
  String get settingsSfx => '音效';

  @override
  String get settingsVoice => '語音';

  @override
  String get settingsMuteAll => '全部靜音';

  @override
  String get settingsPremiumActive => 'Premium 使用中';

  @override
  String get settingsFreePlan => '免費方案';

  @override
  String settingsBilling(String backend) {
    return '付款方式：$backend';
  }

  @override
  String get settingsUnlockAll => '使用 Premium 解鎖所有關卡';

  @override
  String get cancelTitle => '你可以隨時取消';

  @override
  String get cancelBody =>
      '· 除非在當期結束前至少 24 小時取消，否則訂閱會自動續訂。\n\n· iPhone：設定 → Apple ID → 訂閱項目 → Hangul Bricks → 取消\n· 網頁：使用 Lemon Squeezy 收據電子郵件中的連結\n\n· 取消後，Premium 會持續有效至已付費期間結束。\n\n· 在免費試用期間取消，將不會向你收費。';

  @override
  String get cancelOpenSettings => '開啟訂閱設定';

  @override
  String cancelStoreNote(String channel) {
    return '商店版本會開啟系統的訂閱設定（目前管道：$channel）';
  }

  @override
  String get privacyWeb =>
      '· 你的進度與錯題只會儲存在此瀏覽器中，不需要帳號。\n\n· 進行發音評分時，你的聲音會傳送到瀏覽器的語音服務（Chrome 為 Google，Safari 為 Apple）轉換成文字。聲音絕不會傳到 Hangul Bricks 的伺服器，錄音也不會被儲存。\n\n· 麥克風僅用於發音評分。即使拒絕授權，其他功能仍可正常使用。\n\n· 付款由我們的經銷商 Lemon Squeezy 處理，App 絕不會取得你的卡片資料。';

  @override
  String get privacyApp =>
      '· 你的進度與錯題只會儲存在此裝置上，不需要帳號。\n\n· 發音音訊僅在裝置上分析，錄音絕不會被儲存或上傳。\n\n· 麥克風僅用於發音評分。即使拒絕授權，其他功能仍可正常使用。\n\n· 付款透過 App Store App 內購買進行，App 絕不會取得你的卡片資料。';

  @override
  String get termsBody =>
      '· Hangul Bricks 的使用受 Apple 標準 EULA 及我們的網頁服務條款規範。\n\n· 終身方案：一次付費——非訂閱制，不會續訂。\n\n· 除非在當期結束前至少 24 小時取消，否則月繳方案將以相同價格自動續訂。\n\n· 在免費試用期間取消，將不會向你收費。';
}
