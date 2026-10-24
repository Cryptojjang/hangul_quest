// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class L10nVi extends L10n {
  L10nVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Hangul Bricks';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageFollowDevice => 'Ngôn ngữ thiết bị';

  @override
  String get commonNext => 'Tiếp';

  @override
  String get commonSkip => 'Bỏ qua';

  @override
  String get commonPlay => 'Chơi';

  @override
  String get commonGo => 'Đi';

  @override
  String get commonBackToMap => 'Về bản đồ';

  @override
  String get commonFree => 'MIỄN PHÍ';

  @override
  String get commonRestorePurchase => 'Khôi phục giao dịch';

  @override
  String get commonPrivacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get commonTermsOfUse => 'Điều khoản sử dụng';

  @override
  String get commonManageSubscription => 'Quản lý gói đăng ký';

  @override
  String get commonReadFullText => 'Đọc toàn văn';

  @override
  String get commonSummary => 'Tóm tắt';

  @override
  String get commonSubscriptionRestored => 'Đã khôi phục gói đăng ký';

  @override
  String get commonNoSubscription => 'Không có gói đăng ký nào để khôi phục';

  @override
  String commonCouldNotOpen(String url) {
    return 'Không thể mở $url';
  }

  @override
  String get onbHookTitle =>
      'Đọc những bài hát bạn yêu\nbằng chính chữ của chúng';

  @override
  String get onbHookBody =>
      'Hangul là hệ chữ dễ học nhất thế giới — các chữ cái ghép lại với nhau như những khối gạch.';

  @override
  String get onbPromiseTitle => 'Đọc Hangul\ntrong 7 ngày';

  @override
  String get onbPromiseFooter => 'Cứ chơi thôi. Phần còn lại để chúng tôi lo.';

  @override
  String get onbNotifTitle => 'Mỗi ngày 5 phút\ngiữ chuỗi ngày học của bạn';

  @override
  String get onbNotifBody =>
      'Bạn có muốn nhận lời nhắc nhẹ nhàng vào buổi tối không? Không bắt buộc.';

  @override
  String get onbAllowReminders => 'Cho phép nhắc nhở';

  @override
  String get onbGetStarted => 'Bắt đầu';

  @override
  String get onbChooseLanguage => 'Chọn ngôn ngữ của bạn';

  @override
  String trackerHeader(int day) {
    return 'ĐỌC HANGUL TRONG 7 NGÀY · NGÀY $day';
  }

  @override
  String get trackerDay1Title => 'Làm quen phụ âm';

  @override
  String get trackerDay1Goal => 'Nhận biết 10 phụ âm cơ bản';

  @override
  String get trackerDay2Title => 'Cách nguyên âm hoạt động';

  @override
  String get trackerDay2Goal => '6 nguyên âm cơ bản + âm tiết đầu tiên của bạn';

  @override
  String get trackerDay3Title => 'Ghép khối';

  @override
  String get trackerDay3Goal => 'Xếp nguyên âm dọc & ngang';

  @override
  String get trackerDay4Title => 'Phụ âm cuối';

  @override
  String get trackerDay4Goal => 'Âm tiết có batchim';

  @override
  String get trackerDay5Title => 'Âm khó';

  @override
  String get trackerDay5Goal => 'Phụ âm căng & bật hơi';

  @override
  String get trackerDay6Title => 'Đọc từ';

  @override
  String get trackerDay6Goal => 'Đọc 12 từ đầu tiên của bạn';

  @override
  String get trackerDay7Title => 'Đọc thành thạo';

  @override
  String get trackerDay7Goal => 'Đánh vần bất kỳ âm tiết nào';

  @override
  String get homeLearnTitle => 'Học Hangul · 한글 배우기';

  @override
  String get homeLearnSubtitle =>
      'Từ từng chữ cái đến quy tắc đọc · 8 bài miễn phí';

  @override
  String get homeTalkTitle => 'Tiếng Hàn đời thường · 상황별 대화';

  @override
  String get homeTalkSubtitlePremium =>
      'Quán cà phê, taxi, phim Hàn, sự kiện fan và nhiều hơn nữa';

  @override
  String get homeTalkSubtitleFree =>
      '3 hội thoại miễn phí · thêm nữa với Premium';

  @override
  String get homeExploreTitle => 'Khám phá Hàn Quốc · 한국 둘러보기';

  @override
  String get homeExploreSubtitle =>
      'Ứng dụng du lịch, lịch sử và món ăn nên thử';

  @override
  String get homeDailyTitle => 'Thử thách hằng ngày';

  @override
  String get homeDailySubtitle => 'Giữ chuỗi ngày học với một vòng tổng hợp';

  @override
  String get homeStages => 'Màn chơi';

  @override
  String get homeCodex => 'Bộ sưu tập chữ';

  @override
  String homeCodexCount(int count) {
    return '$count / 67 thẻ';
  }

  @override
  String get homeReview => 'Ôn tập thông minh';

  @override
  String get homeReviewUnlimited => 'Không giới hạn';

  @override
  String homeReviewFreeToday(int used) {
    return 'Miễn phí hôm nay $used/1';
  }

  @override
  String get homeLeague => 'Giải đấu tuần · Celadon';

  @override
  String get homeLeagueYou => 'Bạn';

  @override
  String get homeSpeechUnsupported => 'Thiết bị này không hỗ trợ phát âm';

  @override
  String get homeNotSupported => 'Thiết bị này không hỗ trợ';

  @override
  String get stageJamoHunt => 'Săn chữ cái';

  @override
  String get stageJamoHuntSub => 'Nghe âm, chạm vào chữ';

  @override
  String get stageLetterBuilder => 'Ghép chữ';

  @override
  String get stageLetterBuilderSub => 'Ghép chữ cái thành âm tiết';

  @override
  String get stageWordRush => 'Đọc nhanh';

  @override
  String get stageWordRushSub => 'Đọc từ, ghép với hình';

  @override
  String get stagePronunciation => 'Phát âm';

  @override
  String get stagePronunciationSub => 'Chấm điểm phát âm của bạn';

  @override
  String get miniJamoTitle => 'Những chữ cái vẽ nên âm thanh';

  @override
  String get miniJamoBody =>
      'ㄱ thể hiện lưỡi chặn cổ họng, ㅁ thể hiện đôi môi.\nPhụ âm tiếng Hàn là hình vẽ khuôn miệng của bạn.';

  @override
  String get miniJamoPrompt => 'Chạm để nghe âm';

  @override
  String get miniBuilderTitle => 'Vì sao Hangul xếp chồng như những khối gạch?';

  @override
  String get miniBuilderBody =>
      'Phụ âm đầu, nguyên âm và phụ âm cuối xếp thành một khối.\nHình dạng nguyên âm quyết định cách sắp xếp.';

  @override
  String get miniBuilderPrompt => 'Chạm để ghép âm tiết';

  @override
  String get miniWordTitle => 'Giờ hãy đọc từ thật';

  @override
  String get miniWordBody =>
      'Ghép được thì đọc được.\nĐọc nhanh và chọn hình phù hợp.';

  @override
  String get miniWordPrompt => 'Chạm để tạo từ';

  @override
  String get miniSpeakTitle => 'Sẵn sàng nói thành tiếng chưa?';

  @override
  String get miniSpeakBody =>
      'Cuối cùng là nói. Hãy nói vào micro và\nchúng tôi sẽ chấm những âm bạn phát âm chuẩn.';

  @override
  String get miniSpeakPrompt => 'Chạm để nghe trước';

  @override
  String get miniSkip => 'Bỏ qua →';

  @override
  String miniStartsIn(int seconds) {
    return 'Bắt đầu sau $seconds giây';
  }

  @override
  String get miniTapToReplay => 'Chạm để phát lại';

  @override
  String get jamoHuntPrompt => 'Tìm chữ cái cho âm này';

  @override
  String comboActive(int multiplier, int combo) {
    return 'x$multiplier Combo $combo';
  }

  @override
  String comboIdle(int combo) {
    return 'Combo $combo';
  }

  @override
  String get builderPrompt => 'Nghe và ghép âm tiết';

  @override
  String get slotInitial => 'Đầu';

  @override
  String get slotVowel => 'Nguyên âm';

  @override
  String get slotFinal => 'Cuối';

  @override
  String get wordRushPrompt => 'Đọc rồi chọn hình phù hợp';

  @override
  String get pronMicNeeded => 'Cần quyền truy cập micro';

  @override
  String get pronMicBody =>
      'Micro chỉ được dùng để chấm điểm và\nbản ghi âm không bao giờ được lưu lại.\nVui lòng cho phép micro trong cài đặt trình duyệt hoặc thiết bị.';

  @override
  String get pronListenThenSay => 'Nghe rồi nói theo';

  @override
  String get pronTryAgainNext => 'Thử lại / Tiếp';

  @override
  String resultXp(int points) {
    return '+$points XP';
  }

  @override
  String resultBestCombo(int combo) {
    return 'Combo cao nhất $combo';
  }

  @override
  String resultNewCards(int count, String letters) {
    return 'Thẻ mới: $count · $letters';
  }

  @override
  String get resultToReview => 'Âm cần ôn lại';

  @override
  String get resultMissedHint =>
      'Những chữ bạn sai sẽ xuất hiện thường xuyên hơn';

  @override
  String get resultNextLevel => 'Cấp tiếp theo';

  @override
  String get reviewComplete => 'Hoàn thành ôn tập!';

  @override
  String reviewScore(int correct, int total) {
    return 'Đúng $correct / $total';
  }

  @override
  String get reviewTeaserUsed =>
      'Bạn đã dùng lượt ôn tập miễn phí hôm nay.\nPremium mở khóa ôn tập không giới hạn.';

  @override
  String get reviewUnlockUnlimited => 'Mở khóa ôn tập không giới hạn';

  @override
  String reviewHeader(int n, int total) {
    return 'Ôn tập thông minh  $n/$total';
  }

  @override
  String get reviewQuestion => 'Chữ nào phát ra âm này?';

  @override
  String codexTitle(int found, int total) {
    return 'Bộ sưu tập chữ  $found/$total';
  }

  @override
  String get codexInitials => 'Phụ âm đầu';

  @override
  String get codexVowels => 'Nguyên âm';

  @override
  String get codexFinals => 'Phụ âm cuối';

  @override
  String get codexEmptyHint =>
      'Đoán đúng một âm trong Săn chữ cái để mở khóa thẻ đầu tiên.';

  @override
  String get codexLocked => 'Đã khóa';

  @override
  String get codexMastered => '★ Thành thạo';

  @override
  String get codexVelar => 'Có hình gốc lưỡi chặn cổ họng';

  @override
  String get codexAlveolar => 'Có hình đầu lưỡi chạm lợi trên';

  @override
  String get codexLabial => 'Có hình đôi môi';

  @override
  String get codexDental => 'Có hình chiếc răng';

  @override
  String get codexGlottal => 'Có hình cổ họng';

  @override
  String codexCheonjiin(String parts) {
    return 'Tạo từ trời (ㆍ), đất (ㅡ) và người (ㅣ): $parts';
  }

  @override
  String get codexFinalSound => 'Âm của chữ này khi làm phụ âm cuối';

  @override
  String get codexHearIt => 'Nghe';

  @override
  String get learnTitle => 'Học Hangul · 한글 배우기';

  @override
  String get learnIntro =>
      'Mọi thứ bạn cần để đọc tiếng Hàn, trong 8 bài học ngắn.';

  @override
  String learnNext(String title) {
    return 'Tiếp theo: $title';
  }

  @override
  String get learnBackToLessons => 'Về danh sách bài học';

  @override
  String get learnLayoutTall =>
      'nguyên âm dọc: phụ âm bên trái, nguyên âm bên phải';

  @override
  String get learnLayoutFlat =>
      'nguyên âm ngang: phụ âm ở trên, nguyên âm ở dưới';

  @override
  String get learnLayoutMixed => 'nguyên âm ghép: bao bên dưới và bên phải';

  @override
  String get learnPickInitial => '1. Phụ âm đầu';

  @override
  String get learnPickVowel => '2. Nguyên âm';

  @override
  String get learnPickFinal => '3. Phụ âm cuối (tùy chọn)';

  @override
  String learnExample(String words) {
    return 'VD: $words';
  }

  @override
  String get talkTitle => 'Tiếng Hàn đời thường · 상황별 대화';

  @override
  String get talkIntro =>
      'Những câu dùng trong các tình huống bạn sẽ thực sự gặp — chạm vào câu bất kỳ để nghe.';

  @override
  String get talkRomanization => 'Phiên âm La-tinh';

  @override
  String get talkKeyPhrases => 'Câu then chốt';

  @override
  String get talkCultureTip => 'Mẹo văn hóa';

  @override
  String get exploreTitle => 'Khám phá Hàn Quốc · 한국 둘러보기';

  @override
  String get exploreTabApps => 'Ứng dụng';

  @override
  String get exploreTabHistory => 'Lịch sử';

  @override
  String get exploreTabFood => 'Ẩm thực';

  @override
  String get exploreTabSaju => 'Saju';

  @override
  String get exploreAppsIntro =>
      'Hãy cài những ứng dụng này trước khi bay — chúng giúp đi Hàn Quốc dễ dàng hơn.';

  @override
  String exploreTip(String tip) {
    return 'Mẹo: $tip';
  }

  @override
  String get exploreHistoryIntro => '5.000 năm qua 11 điểm dừng.';

  @override
  String get exploreFoodIntro =>
      'Những món nhất định phải thử. Chạm vào nút bản đồ để xem các quán được đánh giá cao gần bạn ngay lúc này — đánh giá trực tiếp, không bao giờ lỗi thời.';

  @override
  String get exploreNaverEnglish =>
      'Dùng Naver Map bằng tiếng Anh: trong ứng dụng, vào MY → Cài đặt → Ngôn ngữ → English.';

  @override
  String exploreWhere(String place) {
    return 'Ở đâu: $place';
  }

  @override
  String get exploreSajuIntro =>
      'Saju (사주) là cách xem vận mệnh của Hàn Quốc dựa trên \"tứ trụ\" gồm năm, tháng, ngày và giờ sinh của bạn. Các cặp đôi thường xem độ hợp nhau — 궁합 — trước những quyết định lớn.';

  @override
  String get exploreViewOnEtsy => 'Xem trên Etsy';

  @override
  String get paywallTitle => 'Đọc Hangul trọn vẹn';

  @override
  String get paywallPronWeb => 'Chấm điểm phát âm (Chrome & Safari)';

  @override
  String get paywallReviewWeb =>
      'Ôn tập thông minh không giới hạn những âm bạn hay sai';

  @override
  String get paywallStagesWeb => 'Mọi cấp độ Ghép chữ cùng Đọc nhanh';

  @override
  String get paywallStreakWeb => 'Sửa chuỗi để bảo vệ chuỗi ngày học';

  @override
  String get paywallPronApp => 'Chấm điểm phát âm cho mọi chữ cái';

  @override
  String get paywallReviewApp => 'Ôn tập thông minh những âm bạn hay sai';

  @override
  String get paywallStagesApp => 'Mọi màn chơi, từ ghép chữ đến đọc từ';

  @override
  String get paywallLoadError => 'Không thể tải các gói';

  @override
  String get paywallNotCompleted => 'Thanh toán chưa hoàn tất';

  @override
  String get paywallError => 'Lỗi thanh toán. Vui lòng thử lại sau ít phút';

  @override
  String get paywallProcessing => 'Đang xử lý…';

  @override
  String paywallStartTrial(int days) {
    return 'Dùng thử miễn phí $days ngày';
  }

  @override
  String get paywallUnlock => 'Mở khóa Premium';

  @override
  String get paywallLifetimeTerms =>
      'Thanh toán một lần · Không phải gói đăng ký · Sở hữu vĩnh viễn';

  @override
  String paywallTrialTerms(String price) {
    return 'Sau đó $price, tự động gia hạn · Hủy bất cứ lúc nào';
  }

  @override
  String paywallRenewTerms(String price) {
    return '$price, tự động gia hạn · Hủy bất cứ lúc nào';
  }

  @override
  String get paywallDemo => 'Thanh toán thử nghiệm: bạn sẽ không bị tính phí';

  @override
  String get paywallHowToCancel => 'Cách hủy';

  @override
  String get planLifetime => 'Trọn đời';

  @override
  String get planYearly => 'Hằng năm';

  @override
  String get planMonthly => 'Hằng tháng';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsMusic => 'Nhạc nền';

  @override
  String get settingsSfx => 'Hiệu ứng âm thanh';

  @override
  String get settingsVoice => 'Giọng đọc';

  @override
  String get settingsMuteAll => 'Tắt toàn bộ âm thanh';

  @override
  String get settingsPremiumActive => 'Premium đang hoạt động';

  @override
  String get settingsFreePlan => 'Gói miễn phí';

  @override
  String settingsBilling(String backend) {
    return 'Thanh toán: $backend';
  }

  @override
  String get settingsUnlockAll => 'Mở khóa mọi màn chơi với Premium';

  @override
  String get cancelTitle => 'Bạn có thể hủy bất cứ lúc nào';

  @override
  String get cancelBody =>
      '· Gói đăng ký tự động gia hạn trừ khi được hủy ít nhất 24 giờ trước khi kỳ hạn kết thúc.\n\n· iPhone: Cài đặt → Apple ID → Đăng ký → Hangul Bricks → Hủy\n· Web: dùng liên kết trong email biên nhận Lemon Squeezy của bạn\n\n· Sau khi hủy, Premium vẫn hoạt động cho đến khi hết kỳ hạn đã thanh toán.\n\n· Nếu hủy trong thời gian dùng thử miễn phí, bạn sẽ không bị tính phí.';

  @override
  String get cancelOpenSettings => 'Mở cài đặt gói đăng ký';

  @override
  String cancelStoreNote(String channel) {
    return 'Bản phát hành trên cửa hàng sẽ mở cài đặt gói đăng ký của hệ điều hành (kênh hiện tại: $channel)';
  }

  @override
  String get privacyWeb =>
      '· Tiến độ và lỗi sai của bạn chỉ được lưu trong trình duyệt này. Không cần tài khoản.\n\n· Để chấm điểm phát âm, giọng nói của bạn được gửi đến dịch vụ nhận dạng giọng nói của trình duyệt (Google trên Chrome, Apple trên Safari) để chuyển thành văn bản. Giọng nói không bao giờ đến máy chủ của Hangul Bricks và bản ghi âm không được lưu lại.\n\n· Micro chỉ được dùng để chấm điểm phát âm. Nếu bạn từ chối, mọi tính năng khác vẫn hoạt động.\n\n· Thanh toán do đơn vị bán lại của chúng tôi là Lemon Squeezy xử lý, và ứng dụng không bao giờ thấy thông tin thẻ của bạn.';

  @override
  String get privacyApp =>
      '· Tiến độ và lỗi sai của bạn chỉ được lưu trên thiết bị này. Không cần tài khoản.\n\n· Âm thanh phát âm chỉ được phân tích trên thiết bị, và bản ghi âm không bao giờ được lưu lại hay tải lên.\n\n· Micro chỉ được dùng để chấm điểm phát âm. Nếu bạn từ chối, mọi tính năng khác vẫn hoạt động.\n\n· Thanh toán được thực hiện qua mua hàng trong ứng dụng của App Store, và ứng dụng không bao giờ thấy thông tin thẻ của bạn.';

  @override
  String get termsBody =>
      '· Việc sử dụng Hangul Bricks tuân theo EULA tiêu chuẩn của Apple và Điều khoản dịch vụ trên web của chúng tôi.\n\n· Trọn đời: Thanh toán một lần — không phải gói đăng ký, không gia hạn.\n\n· Gói hằng tháng tự động gia hạn với cùng mức giá trừ khi được hủy ít nhất 24 giờ trước khi kỳ hạn kết thúc.\n\n· Nếu hủy trong thời gian dùng thử miễn phí, bạn sẽ không bị tính phí.';
}
