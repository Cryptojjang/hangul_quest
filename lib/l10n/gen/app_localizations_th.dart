// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class L10nTh extends L10n {
  L10nTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'Hangul Bricks';

  @override
  String get language => 'ภาษา';

  @override
  String get languageFollowDevice => 'ภาษาของอุปกรณ์';

  @override
  String get commonNext => 'ถัดไป';

  @override
  String get commonSkip => 'ข้าม';

  @override
  String get commonPlay => 'เล่น';

  @override
  String get commonGo => 'ไปเลย';

  @override
  String get commonBackToMap => 'กลับไปที่แผนที่';

  @override
  String get commonFree => 'ฟรี';

  @override
  String get commonRestorePurchase => 'กู้คืนการซื้อ';

  @override
  String get commonPrivacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get commonTermsOfUse => 'ข้อกำหนดการใช้งาน';

  @override
  String get commonManageSubscription => 'จัดการการสมัครสมาชิก';

  @override
  String get commonReadFullText => 'อ่านฉบับเต็ม';

  @override
  String get commonSummary => 'สรุป';

  @override
  String get commonSubscriptionRestored => 'กู้คืนการสมัครสมาชิกแล้ว';

  @override
  String get commonNoSubscription => 'ไม่มีการสมัครสมาชิกให้กู้คืน';

  @override
  String get restoreEmailAction => 'กู้คืนด้วยอีเมล';

  @override
  String get restoreEmailBody =>
      'กรอกอีเมลที่ใช้ตอนชำระเงิน แล้วเราจะส่งรหัสแบบใช้ครั้งเดียวให้';

  @override
  String get restoreEmailField => 'อีเมล';

  @override
  String get restoreEmailSend => 'ส่งรหัส';

  @override
  String get restoreEmailSent =>
      'หากอีเมลนี้มีการซื้อ รหัสกำลังส่งไป ตรวจสอบกล่องจดหมาย (และโฟลเดอร์สแปม)';

  @override
  String get restoreEmailCodeField => 'รหัส';

  @override
  String get restoreEmailConfirm => 'กู้คืน';

  @override
  String get restoreEmailBadCode => 'รหัสไม่ถูกต้องหรือหมดอายุแล้ว';

  @override
  String get restoreEmailError => 'เกิดข้อผิดพลาด โปรดลองอีกครั้ง';

  @override
  String commonCouldNotOpen(String url) {
    return 'ไม่สามารถเปิด $url ได้';
  }

  @override
  String get onbHookTitle => 'อ่านเพลงที่คุณรัก\nด้วยตัวอักษรต้นฉบับ';

  @override
  String get onbHookBody =>
      'ฮันกึลคืออักษรที่เรียนง่ายที่สุดในโลก ตัวอักษรต่อกันได้เหมือนบล็อกตัวต่อ';

  @override
  String get onbPromiseTitle => 'อ่านฮันกึลได้\nใน 7 วัน';

  @override
  String get onbPromiseFooter => 'แค่เล่นไป ที่เหลือเราจัดการเอง';

  @override
  String get onbNotifTitle => 'วันละ 5 นาที\nรักษาสถิติต่อเนื่องไว้ได้';

  @override
  String get onbNotifBody =>
      'อยากได้การแจ้งเตือนเบาๆ ตอนเย็นไหม? เลือกได้ตามใจ';

  @override
  String get onbAllowReminders => 'อนุญาตการแจ้งเตือน';

  @override
  String get onbGetStarted => 'เริ่มต้นใช้งาน';

  @override
  String get onbChooseLanguage => 'เลือกภาษาของคุณ';

  @override
  String trackerHeader(int day) {
    return 'อ่านฮันกึลได้ใน 7 วัน · วันที่ $day';
  }

  @override
  String get trackerDay1Title => 'รู้จักพยัญชนะ';

  @override
  String get trackerDay1Goal => 'จำพยัญชนะพื้นฐาน 10 ตัวได้';

  @override
  String get trackerDay2Title => 'สระทำงานอย่างไร';

  @override
  String get trackerDay2Goal => 'สระพื้นฐาน 6 ตัว + พยางค์แรกของคุณ';

  @override
  String get trackerDay3Title => 'ต่อบล็อกตัวอักษร';

  @override
  String get trackerDay3Goal => 'ประกอบสระแนวตั้งและแนวนอน';

  @override
  String get trackerDay4Title => 'พยัญชนะท้าย';

  @override
  String get trackerDay4Goal => 'พยางค์ที่มีตัวสะกด (batchim)';

  @override
  String get trackerDay5Title => 'เสียงที่แยกยาก';

  @override
  String get trackerDay5Goal => 'พยัญชนะเสียงหนักและเสียงพ่นลม';

  @override
  String get trackerDay6Title => 'อ่านคำศัพท์';

  @override
  String get trackerDay6Goal => 'อ่านคำศัพท์ 12 คำแรกของคุณ';

  @override
  String get trackerDay7Title => 'อ่านคล่อง';

  @override
  String get trackerDay7Goal => 'ออกเสียงได้ทุกพยางค์';

  @override
  String get homeLearnTitle => 'เรียนฮันกึล · 한글 배우기';

  @override
  String get homeLearnSubtitle => 'ตั้งแต่ตัวอักษรถึงกฎการอ่าน · 8 บทเรียนฟรี';

  @override
  String get homeTalkTitle => 'ภาษาเกาหลีในชีวิตจริง · 상황별 대화';

  @override
  String get homeTalkSubtitlePremium =>
      'คาเฟ่ แท็กซี่ ซีรีส์เกาหลี งานแฟนมีต และอีกมากมาย';

  @override
  String get homeTalkSubtitleFree => 'บทสนทนาฟรี 3 บท · เพิ่มอีกด้วย Premium';

  @override
  String get homeExploreTitle => 'สำรวจเกาหลี · 한국 둘러보기';

  @override
  String get homeExploreSubtitle =>
      'แอปท่องเที่ยว ประวัติศาสตร์ และอาหารที่ต้องลอง';

  @override
  String get homeDailyTitle => 'ภารกิจประจำวัน';

  @override
  String get homeDailySubtitle => 'เล่นรอบรวมเพื่อรักษาสถิติต่อเนื่อง';

  @override
  String get homeStages => 'ด่าน';

  @override
  String get homeCodex => 'สมุดสะสมตัวอักษร';

  @override
  String homeCodexCount(int count) {
    return '$count / 67 การ์ด';
  }

  @override
  String get homeReview => 'ทบทวนอัจฉริยะ';

  @override
  String get homeReviewUnlimited => 'ไม่จำกัด';

  @override
  String homeReviewFreeToday(int used) {
    return 'ฟรีวันนี้ $used/1';
  }

  @override
  String get homeLeague => 'ลีกประจำสัปดาห์ · เซลาดอน';

  @override
  String get homeLeagueYou => 'คุณ';

  @override
  String get homeSpeechUnsupported => 'อุปกรณ์นี้ไม่รองรับการออกเสียง';

  @override
  String get homeNotSupported => 'อุปกรณ์นี้ไม่รองรับ';

  @override
  String get stageJamoHunt => 'ล่าตัวอักษร';

  @override
  String get stageJamoHuntSub => 'ฟังเสียง แล้วแตะตัวอักษร';

  @override
  String get stageLetterBuilder => 'ต่อตัวอักษร';

  @override
  String get stageLetterBuilderSub => 'ต่อตัวอักษรให้เป็นพยางค์';

  @override
  String get stageWordRush => 'ซิ่งคำศัพท์';

  @override
  String get stageWordRushSub => 'อ่านคำ แล้วจับคู่กับภาพ';

  @override
  String get stagePronunciation => 'ฝึกออกเสียง';

  @override
  String get stagePronunciationSub => 'ให้คะแนนการออกเสียงของคุณ';

  @override
  String get miniJamoTitle => 'ตัวอักษรที่วาดเสียง';

  @override
  String get miniJamoBody =>
      'ㄱ คือภาพลิ้นที่กั้นลำคอ ㅁ คือภาพริมฝีปาก\nพยัญชนะเกาหลีคือภาพของปากคุณ';

  @override
  String get miniJamoPrompt => 'แตะเพื่อฟังเสียง';

  @override
  String get miniBuilderTitle => 'ทำไมฮันกึลถึงซ้อนกันเหมือนบล็อก?';

  @override
  String get miniBuilderBody =>
      'พยัญชนะต้น สระ และตัวสะกดซ้อนกันเป็นหนึ่งบล็อก\nรูปร่างของสระเป็นตัวกำหนดการจัดวาง';

  @override
  String get miniBuilderPrompt => 'แตะเพื่อต่อพยางค์';

  @override
  String get miniWordTitle => 'ทีนี้มาอ่านคำจริงกัน';

  @override
  String get miniWordBody =>
      'ถ้าต่อได้ ก็อ่านได้\nอ่านให้เร็วแล้วเลือกภาพที่ตรงกัน';

  @override
  String get miniWordPrompt => 'แตะเพื่อสร้างคำ';

  @override
  String get miniSpeakTitle => 'พร้อมพูดออกเสียงหรือยัง?';

  @override
  String get miniSpeakBody =>
      'สุดท้ายคือการพูด พูดใส่ไมค์แล้ว\nเราจะให้คะแนนว่าเสียงไหนที่คุณพูดได้เป๊ะ';

  @override
  String get miniSpeakPrompt => 'แตะเพื่อฟังก่อน';

  @override
  String get miniSkip => 'ข้าม →';

  @override
  String miniStartsIn(int seconds) {
    return 'เริ่มใน $seconds วินาที';
  }

  @override
  String get miniTapToReplay => 'แตะเพื่อเล่นซ้ำ';

  @override
  String get jamoHuntPrompt => 'หาตัวอักษรของเสียงนี้';

  @override
  String comboActive(int multiplier, int combo) {
    return 'x$multiplier คอมโบ $combo';
  }

  @override
  String comboIdle(int combo) {
    return 'คอมโบ $combo';
  }

  @override
  String get builderPrompt => 'ฟังแล้วต่อพยางค์';

  @override
  String get slotInitial => 'ต้น';

  @override
  String get slotVowel => 'สระ';

  @override
  String get slotFinal => 'ตัวสะกด';

  @override
  String get wordRushPrompt => 'อ่านแล้วเลือกภาพที่ตรงกัน';

  @override
  String get pronMicNeeded => 'ต้องการสิทธิ์เข้าถึงไมโครโฟน';

  @override
  String get pronMicBody =>
      'ไมค์ใช้สำหรับให้คะแนนเท่านั้น\nและจะไม่มีการเก็บเสียงที่บันทึกไว้\nโปรดอนุญาตไมโครโฟนในการตั้งค่าเบราว์เซอร์หรืออุปกรณ์';

  @override
  String get pronListenThenSay => 'ฟังแล้วพูดตาม';

  @override
  String get pronTryAgainNext => 'ลองอีกครั้ง / ถัดไป';

  @override
  String resultXp(int points) {
    return '+$points XP';
  }

  @override
  String resultBestCombo(int combo) {
    return 'คอมโบสูงสุด $combo';
  }

  @override
  String resultNewCards(int count, String letters) {
    return 'การ์ดใหม่: $count ใบ · $letters';
  }

  @override
  String get resultToReview => 'เสียงที่ควรทบทวน';

  @override
  String get resultMissedHint => 'ตัวอักษรที่คุณตอบผิดจะปรากฏบ่อยขึ้น';

  @override
  String get resultNextLevel => 'ด่านถัดไป';

  @override
  String get reviewComplete => 'ทบทวนเสร็จแล้ว!';

  @override
  String reviewScore(int correct, int total) {
    return 'ถูก $correct / $total';
  }

  @override
  String get reviewTeaserUsed =>
      'ใช้สิทธิ์ทบทวนฟรีของวันนี้แล้ว\nPremium ทบทวนได้ไม่จำกัด';

  @override
  String get reviewUnlockUnlimited => 'ปลดล็อกการทบทวนไม่จำกัด';

  @override
  String reviewHeader(int n, int total) {
    return 'ทบทวนอัจฉริยะ  $n/$total';
  }

  @override
  String get reviewQuestion => 'ตัวอักษรไหนออกเสียงนี้?';

  @override
  String codexTitle(int found, int total) {
    return 'สมุดสะสมตัวอักษร  $found/$total';
  }

  @override
  String get codexInitials => 'พยัญชนะต้น';

  @override
  String get codexVowels => 'สระ';

  @override
  String get codexFinals => 'พยัญชนะท้าย';

  @override
  String get codexEmptyHint =>
      'ตอบเสียงให้ถูกในด่านล่าตัวอักษรเพื่อปลดล็อกการ์ดใบแรก';

  @override
  String get codexLocked => 'ล็อกอยู่';

  @override
  String get codexMastered => '★ เชี่ยวชาญแล้ว';

  @override
  String get codexVelar => 'รูปร่างเหมือนโคนลิ้นที่กั้นลำคอ';

  @override
  String get codexAlveolar => 'รูปร่างเหมือนปลายลิ้นแตะปุ่มเหงือก';

  @override
  String get codexLabial => 'รูปร่างเหมือนริมฝีปาก';

  @override
  String get codexDental => 'รูปร่างเหมือนฟัน';

  @override
  String get codexGlottal => 'รูปร่างเหมือนลำคอ';

  @override
  String codexCheonjiin(String parts) {
    return 'สร้างจากฟ้า (ㆍ) ดิน (ㅡ) และคน (ㅣ): $parts';
  }

  @override
  String get codexFinalSound => 'เสียงเมื่อเป็นตัวสะกด';

  @override
  String get codexHearIt => 'ฟังเสียง';

  @override
  String get learnTitle => 'เรียนฮันกึล · 한글 배우기';

  @override
  String get learnIntro =>
      'ทุกอย่างที่ต้องรู้เพื่ออ่านภาษาเกาหลี ใน 8 บทเรียนสั้นๆ';

  @override
  String learnNext(String title) {
    return 'ถัดไป: $title';
  }

  @override
  String get learnBackToLessons => 'กลับไปที่บทเรียน';

  @override
  String get learnLayoutTall => 'สระแนวตั้ง: พยัญชนะซ้าย สระขวา';

  @override
  String get learnLayoutFlat => 'สระแนวนอน: พยัญชนะบน สระล่าง';

  @override
  String get learnLayoutMixed => 'สระผสม: ล้อมด้านล่างและด้านขวา';

  @override
  String get learnPickInitial => '1. พยัญชนะต้น';

  @override
  String get learnPickVowel => '2. สระ';

  @override
  String get learnPickFinal => '3. ตัวสะกด (ไม่บังคับ)';

  @override
  String learnExample(String words) {
    return 'เช่น $words';
  }

  @override
  String get talkTitle => 'ภาษาเกาหลีในชีวิตจริง · 상황별 대화';

  @override
  String get talkIntro =>
      'ประโยคสำหรับสถานการณ์ที่คุณจะเจอจริง แตะประโยคไหนก็ได้เพื่อฟังเสียง';

  @override
  String get talkRomanization => 'คำอ่านอักษรโรมัน';

  @override
  String get talkKeyPhrases => 'ประโยคสำคัญ';

  @override
  String get talkCultureTip => 'เกร็ดวัฒนธรรม';

  @override
  String get exploreTitle => 'สำรวจเกาหลี · 한국 둘러보기';

  @override
  String get exploreTabApps => 'แอป';

  @override
  String get exploreTabHistory => 'ประวัติศาสตร์';

  @override
  String get exploreTabFood => 'อาหาร';

  @override
  String get exploreTabSaju => 'ซาจู';

  @override
  String get exploreAppsIntro =>
      'ติดตั้งแอปเหล่านี้ก่อนบิน แล้วเที่ยวเกาหลีจะง่ายขึ้นเยอะ';

  @override
  String exploreTip(String tip) {
    return 'เคล็ดลับ: $tip';
  }

  @override
  String get exploreHistoryIntro => '5,000 ปีใน 11 จุดแวะพัก';

  @override
  String get exploreFoodIntro =>
      'เมนูที่ต้องลอง แตะปุ่มแผนที่เพื่อดูร้านที่ได้คะแนนสูงสุดใกล้คุณตอนนี้ คะแนนสด ไม่มีวันล้าสมัย';

  @override
  String get exploreNaverEnglish =>
      'ใช้ Naver Map เป็นภาษาอังกฤษ: ในแอปไปที่ MY → การตั้งค่า → ภาษา → English';

  @override
  String exploreWhere(String place) {
    return 'สถานที่: $place';
  }

  @override
  String get exploreSajuIntro =>
      'ซาจู (사주) คือการดูดวงแบบเกาหลีจาก \"สี่เสาหลัก\" ได้แก่ ปี เดือน วัน และเวลาเกิดของคุณ คู่รักมักดูดวงสมพงษ์ หรือ 궁합 ก่อนตัดสินใจเรื่องสำคัญ';

  @override
  String get exploreViewOnEtsy => 'ดูบน Etsy';

  @override
  String get paywallTitle => 'อ่านฮันกึลได้อย่างสมบูรณ์';

  @override
  String get paywallPronWeb => 'ให้คะแนนการออกเสียง (Chrome และ Safari)';

  @override
  String get paywallReviewWeb => 'ทบทวนอัจฉริยะเสียงที่คุณตอบผิดได้ไม่จำกัด';

  @override
  String get paywallStagesWeb => 'ทุกด่านต่อตัวอักษร พร้อมซิ่งคำศัพท์';

  @override
  String get paywallStreakWeb => 'ซ่อมสถิติต่อเนื่องเพื่อปกป้องสถิติของคุณ';

  @override
  String get paywallPronApp => 'ให้คะแนนการออกเสียงทุกตัวอักษร';

  @override
  String get paywallReviewApp => 'ทบทวนอัจฉริยะเสียงที่คุณตอบผิด';

  @override
  String get paywallStagesApp => 'ทุกด่าน ตั้งแต่ต่อตัวอักษรจนถึงอ่านคำศัพท์';

  @override
  String get paywallLoadError => 'ไม่สามารถโหลดแพ็กเกจได้';

  @override
  String get paywallNotCompleted => 'การชำระเงินไม่สำเร็จ';

  @override
  String get paywallError =>
      'เกิดข้อผิดพลาดในการชำระเงิน โปรดลองอีกครั้งในอีกสักครู่';

  @override
  String get paywallProcessing => 'กำลังดำเนินการ…';

  @override
  String paywallStartTrial(int days) {
    return 'เริ่มทดลองใช้ฟรี $days วัน';
  }

  @override
  String get paywallUnlock => 'ปลดล็อก Premium';

  @override
  String get paywallLifetimeTerms =>
      'ชำระครั้งเดียว · ไม่ใช่การสมัครสมาชิก · เป็นของคุณตลอดไป';

  @override
  String paywallTrialTerms(String price) {
    return 'จากนั้น $price ต่ออายุอัตโนมัติ · ยกเลิกได้ทุกเมื่อ';
  }

  @override
  String paywallRenewTerms(String price) {
    return '$price ต่ออายุอัตโนมัติ · ยกเลิกได้ทุกเมื่อ';
  }

  @override
  String get paywallDemo => 'การชำระเงินทดลอง: คุณจะไม่ถูกเรียกเก็บเงิน';

  @override
  String get paywallHowToCancel => 'วิธียกเลิก';

  @override
  String get planLifetime => 'ตลอดชีพ';

  @override
  String get planYearly => 'รายปี';

  @override
  String get planMonthly => 'รายเดือน';

  @override
  String get settingsTitle => 'การตั้งค่า';

  @override
  String get settingsMusic => 'เพลง';

  @override
  String get settingsSfx => 'เสียงเอฟเฟกต์';

  @override
  String get settingsVoice => 'เสียงพูด';

  @override
  String get settingsMuteAll => 'ปิดเสียงทั้งหมด';

  @override
  String get settingsPremiumActive => 'Premium ใช้งานอยู่';

  @override
  String get settingsFreePlan => 'แพ็กเกจฟรี';

  @override
  String settingsBilling(String backend) {
    return 'การชำระเงิน: $backend';
  }

  @override
  String get settingsUnlockAll => 'ปลดล็อกทุกด่านด้วย Premium';

  @override
  String get cancelTitle => 'คุณยกเลิกได้ทุกเมื่อ';

  @override
  String get cancelBody =>
      '· การสมัครสมาชิกจะต่ออายุโดยอัตโนมัติ เว้นแต่จะยกเลิกอย่างน้อย 24 ชั่วโมงก่อนสิ้นสุดรอบปัจจุบัน\n\n· iPhone: การตั้งค่า → Apple ID → การสมัครสมาชิก → Hangul Bricks → ยกเลิก\n· เว็บ: ใช้ลิงก์ในอีเมลใบเสร็จจาก Lemon Squeezy\n\n· หลังยกเลิก Premium จะยังใช้งานได้จนกว่ารอบที่ชำระเงินแล้วจะสิ้นสุด\n\n· หากยกเลิกระหว่างช่วงทดลองใช้ฟรี คุณจะไม่ถูกเรียกเก็บเงิน';

  @override
  String get cancelOpenSettings => 'เปิดการตั้งค่าการสมัครสมาชิก';

  @override
  String cancelStoreNote(String channel) {
    return 'เวอร์ชันสโตร์จะเปิดการตั้งค่าการสมัครสมาชิกของระบบ (ช่องทางปัจจุบัน: $channel)';
  }

  @override
  String get privacyWeb =>
      '· ความคืบหน้าและข้อผิดพลาดของคุณจะถูกบันทึกไว้ในเบราว์เซอร์นี้เท่านั้น ไม่ต้องมีบัญชี\n\n· สำหรับการให้คะแนนการออกเสียง เสียงของคุณจะถูกส่งไปยังบริการเสียงพูดของเบราว์เซอร์ (Google ใน Chrome, Apple ใน Safari) เพื่อแปลงเป็นข้อความ เสียงจะไม่ถูกส่งถึงเซิร์ฟเวอร์ของ Hangul Bricks และจะไม่มีการเก็บไฟล์บันทึกเสียง\n\n· ไมโครโฟนใช้สำหรับให้คะแนนการออกเสียงเท่านั้น หากคุณไม่อนุญาต ฟีเจอร์อื่นๆ ทั้งหมดยังใช้งานได้ตามปกติ\n\n· การชำระเงินดำเนินการโดย Lemon Squeezy ผู้จัดจำหน่ายของเรา และแอปจะไม่เห็นข้อมูลบัตรของคุณ';

  @override
  String get privacyApp =>
      '· ความคืบหน้าและข้อผิดพลาดของคุณจะถูกบันทึกไว้ในอุปกรณ์นี้เท่านั้น ไม่ต้องมีบัญชี\n\n· เสียงสำหรับการออกเสียงจะถูกวิเคราะห์บนอุปกรณ์เท่านั้น และจะไม่มีการเก็บหรืออัปโหลดไฟล์บันทึกเสียง\n\n· ไมโครโฟนใช้สำหรับให้คะแนนการออกเสียงเท่านั้น หากคุณไม่อนุญาต ฟีเจอร์อื่นๆ ทั้งหมดยังใช้งานได้ตามปกติ\n\n· การชำระเงินทำผ่านการซื้อภายในแอปของ App Store และแอปจะไม่เห็นข้อมูลบัตรของคุณ';

  @override
  String get termsBody =>
      '· การใช้งาน Hangul Bricks อยู่ภายใต้ EULA มาตรฐานของ Apple และข้อกำหนดการให้บริการบนเว็บของเรา\n\n· ตลอดชีพ: ชำระครั้งเดียว ไม่ใช่การสมัครสมาชิก ไม่มีการต่ออายุ\n\n· แพ็กเกจรายเดือนจะต่ออายุโดยอัตโนมัติในราคาเดิม เว้นแต่จะยกเลิกอย่างน้อย 24 ชั่วโมงก่อนสิ้นสุดรอบปัจจุบัน\n\n· หากยกเลิกระหว่างช่วงทดลองใช้ฟรี คุณจะไม่ถูกเรียกเก็บเงิน';
}
