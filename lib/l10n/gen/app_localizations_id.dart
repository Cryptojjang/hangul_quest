// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class L10nId extends L10n {
  L10nId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Hangul Bricks';

  @override
  String get language => 'Bahasa';

  @override
  String get languageFollowDevice => 'Bahasa perangkat';

  @override
  String get commonNext => 'Lanjut';

  @override
  String get commonSkip => 'Lewati';

  @override
  String get commonPlay => 'Main';

  @override
  String get commonGo => 'Ayo';

  @override
  String get commonBackToMap => 'Kembali ke peta';

  @override
  String get commonFree => 'GRATIS';

  @override
  String get commonRestorePurchase => 'Pulihkan pembelian';

  @override
  String get commonPrivacyPolicy => 'Kebijakan Privasi';

  @override
  String get commonTermsOfUse => 'Ketentuan Penggunaan';

  @override
  String get commonManageSubscription => 'Kelola langganan';

  @override
  String get commonReadFullText => 'Baca teks lengkap';

  @override
  String get commonSummary => 'Ringkasan';

  @override
  String get commonSubscriptionRestored => 'Langganan dipulihkan';

  @override
  String get commonNoSubscription => 'Tidak ada langganan untuk dipulihkan';

  @override
  String get restoreEmailAction => 'Pulihkan dengan email';

  @override
  String get restoreEmailBody =>
      'Masukkan email yang kamu pakai saat membayar. Kami akan mengirim kode sekali pakai.';

  @override
  String get restoreEmailField => 'Email';

  @override
  String get restoreEmailSend => 'Kirim kode';

  @override
  String get restoreEmailSent =>
      'Jika email ini memiliki pembelian, kode sedang dikirim. Periksa kotak masuk (dan folder spam).';

  @override
  String get restoreEmailCodeField => 'Kode';

  @override
  String get restoreEmailConfirm => 'Pulihkan';

  @override
  String get restoreEmailBadCode => 'Kode salah atau sudah kedaluwarsa.';

  @override
  String get restoreEmailError => 'Terjadi kesalahan. Coba lagi.';

  @override
  String commonCouldNotOpen(String url) {
    return 'Tidak dapat membuka $url';
  }

  @override
  String get onbHookTitle => 'Baca lagu favoritmu\ndalam huruf aslinya';

  @override
  String get onbHookBody =>
      'Hangul adalah aksara termudah di dunia untuk dipelajari — hurufnya menyatu seperti balok.';

  @override
  String get onbPromiseTitle => 'Baca Hangul\ndalam 7 hari';

  @override
  String get onbPromiseFooter => 'Main saja. Sisanya biar kami yang urus.';

  @override
  String get onbNotifTitle => '5 menit sehari\nmenjaga streak-mu tetap hidup';

  @override
  String get onbNotifBody =>
      'Mau pengingat ringan di malam hari? Ini opsional.';

  @override
  String get onbAllowReminders => 'Izinkan pengingat';

  @override
  String get onbGetStarted => 'Mulai';

  @override
  String get onbChooseLanguage => 'Pilih bahasamu';

  @override
  String trackerHeader(int day) {
    return 'BACA HANGUL DALAM 7 HARI · HARI $day';
  }

  @override
  String get trackerDay1Title => 'Kenalan dengan konsonan';

  @override
  String get trackerDay1Goal => 'Kenali 10 konsonan dasar';

  @override
  String get trackerDay2Title => 'Cara kerja vokal';

  @override
  String get trackerDay2Goal => '6 vokal dasar + suku kata pertamamu';

  @override
  String get trackerDay3Title => 'Menyusun balok';

  @override
  String get trackerDay3Goal => 'Susun vokal vertikal & horizontal';

  @override
  String get trackerDay4Title => 'Konsonan akhir';

  @override
  String get trackerDay4Goal => 'Suku kata dengan batchim';

  @override
  String get trackerDay5Title => 'Bunyi yang rumit';

  @override
  String get trackerDay5Goal => 'Konsonan tegang & beraspirasi';

  @override
  String get trackerDay6Title => 'Membaca kata';

  @override
  String get trackerDay6Goal => 'Baca 12 kata pertamamu';

  @override
  String get trackerDay7Title => 'Pembaca lancar';

  @override
  String get trackerDay7Goal => 'Lafalkan suku kata apa pun';

  @override
  String get homeLearnTitle => 'Belajar Hangul · 한글 배우기';

  @override
  String get homeLearnSubtitle =>
      'Dari setiap huruf hingga aturan membaca · 8 pelajaran gratis';

  @override
  String get homeTalkTitle => 'Bahasa Korea sehari-hari · 상황별 대화';

  @override
  String get homeTalkSubtitlePremium =>
      'Kafe, taksi, drama Korea, acara fan, dan lainnya';

  @override
  String get homeTalkSubtitleFree =>
      '3 percakapan gratis · lebih banyak dengan Premium';

  @override
  String get homeExploreTitle => 'Jelajahi Korea · 한국 둘러보기';

  @override
  String get homeExploreSubtitle =>
      'Aplikasi perjalanan, sejarah, dan makanan untuk dicoba';

  @override
  String get homeDailyTitle => 'Tantangan Harian';

  @override
  String get homeDailySubtitle => 'Jaga streak-mu dengan ronde campuran';

  @override
  String get homeStages => 'Tahap';

  @override
  String get homeCodex => 'Koleksi Huruf';

  @override
  String homeCodexCount(int count) {
    return '$count / 67 kartu';
  }

  @override
  String get homeReview => 'Ulasan Pintar';

  @override
  String get homeReviewUnlimited => 'Tanpa batas';

  @override
  String homeReviewFreeToday(int used) {
    return 'Gratis hari ini $used/1';
  }

  @override
  String get homeLeague => 'Liga Mingguan · Celadon';

  @override
  String get homeLeagueYou => 'Kamu';

  @override
  String get homeSpeechUnsupported =>
      'Pelafalan tidak didukung di perangkat ini';

  @override
  String get homeNotSupported => 'Tidak didukung di perangkat ini';

  @override
  String get stageJamoHunt => 'Berburu Jamo';

  @override
  String get stageJamoHuntSub => 'Dengar bunyinya, ketuk hurufnya';

  @override
  String get stageLetterBuilder => 'Rakit Huruf';

  @override
  String get stageLetterBuilderSub => 'Gabungkan huruf menjadi suku kata';

  @override
  String get stageWordRush => 'Kilat Kata';

  @override
  String get stageWordRushSub => 'Baca kata, cocokkan gambar';

  @override
  String get stagePronunciation => 'Pelafalan';

  @override
  String get stagePronunciationSub => 'Dapatkan skor pelafalanmu';

  @override
  String get miniJamoTitle => 'Huruf yang menggambar bunyi';

  @override
  String get miniJamoBody =>
      'ㄱ menggambarkan lidah yang menutup tenggorokan, ㅁ menggambarkan bibir.\nKonsonan Korea adalah gambar mulutmu.';

  @override
  String get miniJamoPrompt => 'Ketuk untuk mendengar bunyinya';

  @override
  String get miniBuilderTitle => 'Kenapa Hangul tersusun seperti balok?';

  @override
  String get miniBuilderBody =>
      'Huruf awal, vokal, dan huruf akhir tersusun menjadi satu blok.\nBentuk vokal menentukan tata letaknya.';

  @override
  String get miniBuilderPrompt => 'Ketuk untuk merakit suku kata';

  @override
  String get miniWordTitle => 'Sekarang baca kata sungguhan';

  @override
  String get miniWordBody =>
      'Kalau bisa merakitnya, kamu bisa membacanya.\nBaca dengan cepat dan pilih gambar yang cocok.';

  @override
  String get miniWordPrompt => 'Ketuk untuk membentuk kata';

  @override
  String get miniSpeakTitle => 'Siap mengucapkannya dengan lantang?';

  @override
  String get miniSpeakBody =>
      'Terakhir, berbicara. Ucapkan ke mikrofon dan\nkami beri skor bunyi mana yang sudah tepat.';

  @override
  String get miniSpeakPrompt => 'Ketuk untuk mendengar dulu';

  @override
  String get miniSkip => 'Lewati →';

  @override
  String miniStartsIn(int seconds) {
    return 'Mulai dalam $seconds dtk';
  }

  @override
  String get miniTapToReplay => 'Ketuk untuk memutar ulang';

  @override
  String get jamoHuntPrompt => 'Temukan huruf untuk bunyi ini';

  @override
  String comboActive(int multiplier, int combo) {
    return 'x$multiplier Kombo $combo';
  }

  @override
  String comboIdle(int combo) {
    return 'Kombo $combo';
  }

  @override
  String get builderPrompt => 'Dengarkan lalu rakit suku katanya';

  @override
  String get slotInitial => 'Awal';

  @override
  String get slotVowel => 'Vokal';

  @override
  String get slotFinal => 'Akhir';

  @override
  String get wordRushPrompt => 'Baca, lalu pilih gambar yang cocok';

  @override
  String get pronMicNeeded => 'Perlu akses mikrofon';

  @override
  String get pronMicBody =>
      'Mikrofon hanya digunakan untuk penilaian dan\nrekaman tidak pernah disimpan.\nIzinkan mikrofon di pengaturan browser atau perangkatmu.';

  @override
  String get pronListenThenSay => 'Dengarkan, lalu ucapkan';

  @override
  String get pronTryAgainNext => 'Coba lagi / Lanjut';

  @override
  String resultXp(int points) {
    return '+$points XP';
  }

  @override
  String resultBestCombo(int combo) {
    return 'Kombo terbaik $combo';
  }

  @override
  String resultNewCards(int count, String letters) {
    return 'Kartu koleksi baru: $count · $letters';
  }

  @override
  String get resultToReview => 'Bunyi untuk diulas';

  @override
  String get resultMissedHint =>
      'Huruf yang sering salah akan muncul lebih sering';

  @override
  String get resultNextLevel => 'Level berikutnya';

  @override
  String get reviewComplete => 'Ulasan selesai!';

  @override
  String reviewScore(int correct, int total) {
    return '$correct / $total benar';
  }

  @override
  String get reviewTeaserUsed =>
      'Ulasan gratis hari ini sudah dipakai.\nPremium membuka ulasan tanpa batas.';

  @override
  String get reviewUnlockUnlimited => 'Buka ulasan tanpa batas';

  @override
  String reviewHeader(int n, int total) {
    return 'Ulasan Pintar  $n/$total';
  }

  @override
  String get reviewQuestion => 'Huruf mana yang berbunyi seperti ini?';

  @override
  String codexTitle(int found, int total) {
    return 'Koleksi Huruf  $found/$total';
  }

  @override
  String get codexInitials => 'Konsonan awal';

  @override
  String get codexVowels => 'Vokal';

  @override
  String get codexFinals => 'Konsonan akhir';

  @override
  String get codexEmptyHint =>
      'Tebak satu bunyi dengan benar di Berburu Jamo untuk membuka kartu pertamamu.';

  @override
  String get codexLocked => 'Terkunci';

  @override
  String get codexMastered => '★ Dikuasai';

  @override
  String get codexVelar => 'Berbentuk pangkal lidah yang menutup tenggorokan';

  @override
  String get codexAlveolar => 'Berbentuk ujung lidah yang menyentuh gusi';

  @override
  String get codexLabial => 'Berbentuk bibir';

  @override
  String get codexDental => 'Berbentuk gigi';

  @override
  String get codexGlottal => 'Berbentuk tenggorokan';

  @override
  String codexCheonjiin(String parts) {
    return 'Dibentuk dari langit (ㆍ), bumi (ㅡ), dan manusia (ㅣ): $parts';
  }

  @override
  String get codexFinalSound => 'Bunyinya saat menjadi konsonan akhir';

  @override
  String get codexHearIt => 'Dengarkan';

  @override
  String get learnTitle => 'Belajar Hangul · 한글 배우기';

  @override
  String get learnIntro =>
      'Semua yang kamu perlukan untuk membaca bahasa Korea, dalam 8 pelajaran singkat.';

  @override
  String learnNext(String title) {
    return 'Berikutnya: $title';
  }

  @override
  String get learnBackToLessons => 'Kembali ke pelajaran';

  @override
  String get learnLayoutTall => 'vokal tegak: konsonan di kiri, vokal di kanan';

  @override
  String get learnLayoutFlat => 'vokal datar: konsonan di atas, vokal di bawah';

  @override
  String get learnLayoutMixed => 'vokal gabungan: melingkupi bawah dan kanan';

  @override
  String get learnPickInitial => '1. Konsonan awal';

  @override
  String get learnPickVowel => '2. Vokal';

  @override
  String get learnPickFinal => '3. Konsonan akhir (opsional)';

  @override
  String learnExample(String words) {
    return 'mis. $words';
  }

  @override
  String get talkTitle => 'Bahasa Korea sehari-hari · 상황별 대화';

  @override
  String get talkIntro =>
      'Ungkapan untuk momen yang benar-benar akan kamu alami — ketuk baris mana saja untuk mendengarnya.';

  @override
  String get talkRomanization => 'Romanisasi';

  @override
  String get talkKeyPhrases => 'Ungkapan kunci';

  @override
  String get talkCultureTip => 'Tips budaya';

  @override
  String get exploreTitle => 'Jelajahi Korea · 한국 둘러보기';

  @override
  String get exploreTabApps => 'Aplikasi';

  @override
  String get exploreTabHistory => 'Sejarah';

  @override
  String get exploreTabFood => 'Makanan';

  @override
  String get exploreTabSaju => 'Saju';

  @override
  String get exploreAppsIntro =>
      'Pasang aplikasi ini sebelum terbang — semuanya membuat Korea jadi mudah.';

  @override
  String exploreTip(String tip) {
    return 'Tips: $tip';
  }

  @override
  String get exploreHistoryIntro => '5.000 tahun dalam 11 perhentian.';

  @override
  String get exploreFoodIntro =>
      'Hidangan wajib coba. Ketuk tombol peta untuk melihat tempat dengan rating tertinggi di dekatmu saat ini — rating langsung, tidak pernah ketinggalan zaman.';

  @override
  String get exploreNaverEnglish =>
      'Naver Map dalam bahasa Inggris: di aplikasi, buka MY → Pengaturan → Bahasa → English.';

  @override
  String exploreWhere(String place) {
    return 'Lokasi: $place';
  }

  @override
  String get exploreSajuIntro =>
      'Saju (사주) adalah ramalan nasib Korea berdasarkan \"empat pilar\" tahun, bulan, hari, dan jam kelahiranmu. Pasangan memeriksa kecocokan mereka — 궁합 — sebelum mengambil keputusan besar.';

  @override
  String get exploreViewOnEtsy => 'Lihat di Etsy';

  @override
  String get paywallTitle => 'Baca Hangul sepenuhnya';

  @override
  String get paywallPronWeb => 'Penilaian pelafalan (Chrome & Safari)';

  @override
  String get paywallReviewWeb =>
      'Ulasan Pintar tanpa batas untuk bunyi yang sering salah';

  @override
  String get paywallStagesWeb => 'Semua level Rakit Huruf plus Kilat Kata';

  @override
  String get paywallStreakWeb => 'Perbaikan streak untuk melindungi streak-mu';

  @override
  String get paywallPronApp => 'Penilaian pelafalan untuk setiap huruf';

  @override
  String get paywallReviewApp => 'Ulasan Pintar untuk bunyi yang sering salah';

  @override
  String get paywallStagesApp =>
      'Semua tahap, dari merakit huruf hingga membaca kata';

  @override
  String get paywallLoadError => 'Tidak dapat memuat paket';

  @override
  String get paywallNotCompleted => 'Pembayaran tidak selesai';

  @override
  String get paywallError =>
      'Terjadi kesalahan pembayaran. Silakan coba lagi sebentar lagi';

  @override
  String get paywallProcessing => 'Memproses…';

  @override
  String paywallStartTrial(int days) {
    return 'Mulai uji coba gratis $days hari';
  }

  @override
  String get paywallUnlock => 'Buka Premium';

  @override
  String get paywallLifetimeTerms =>
      'Pembayaran sekali · Tanpa langganan · Milikmu selamanya';

  @override
  String paywallTrialTerms(String price) {
    return 'Lalu $price, diperpanjang otomatis · Batalkan kapan saja';
  }

  @override
  String paywallRenewTerms(String price) {
    return '$price, diperpanjang otomatis · Batalkan kapan saja';
  }

  @override
  String get paywallDemo => 'Checkout demo: kamu tidak akan dikenai biaya';

  @override
  String get paywallHowToCancel => 'Cara membatalkan';

  @override
  String get planLifetime => 'Seumur hidup';

  @override
  String get planYearly => 'Tahunan';

  @override
  String get planMonthly => 'Bulanan';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsMusic => 'Musik';

  @override
  String get settingsSfx => 'Efek suara';

  @override
  String get settingsVoice => 'Suara';

  @override
  String get settingsMuteAll => 'Bisukan semua';

  @override
  String get settingsPremiumActive => 'Premium aktif';

  @override
  String get settingsFreePlan => 'Paket gratis';

  @override
  String settingsBilling(String backend) {
    return 'Penagihan: $backend';
  }

  @override
  String get settingsUnlockAll => 'Buka semua tahap dengan Premium';

  @override
  String get cancelTitle => 'Kamu bisa membatalkan kapan saja';

  @override
  String get cancelBody =>
      '· Langganan diperpanjang secara otomatis kecuali dibatalkan setidaknya 24 jam sebelum periode berakhir.\n\n· iPhone: Pengaturan → Apple ID → Langganan → Hangul Bricks → Batalkan\n· Web: gunakan tautan di email tanda terima Lemon Squeezy-mu\n\n· Setelah dibatalkan, Premium tetap aktif hingga periode yang sudah dibayar berakhir.\n\n· Batalkan selama uji coba gratis dan kamu tidak akan dikenai biaya.';

  @override
  String get cancelOpenSettings => 'Buka pengaturan langganan';

  @override
  String cancelStoreNote(String channel) {
    return 'Versi toko membuka pengaturan langganan OS (kanal saat ini: $channel)';
  }

  @override
  String get privacyWeb =>
      '· Progres dan kesalahanmu hanya disimpan di browser ini. Tidak perlu akun.\n\n· Untuk penilaian pelafalan, suaramu dikirim ke layanan ucapan milik browser (Google di Chrome, Apple di Safari) untuk diubah menjadi teks. Suaramu tidak pernah sampai ke server Hangul Bricks dan rekaman tidak disimpan.\n\n· Mikrofon hanya digunakan untuk penilaian pelafalan. Jika kamu menolaknya, semua fitur lain tetap berfungsi.\n\n· Pembayaran ditangani oleh reseller kami, Lemon Squeezy, dan aplikasi tidak pernah melihat detail kartumu.';

  @override
  String get privacyApp =>
      '· Progres dan kesalahanmu hanya disimpan di perangkat ini. Tidak perlu akun.\n\n· Audio pelafalan hanya dianalisis di perangkat, dan rekaman tidak pernah disimpan atau diunggah.\n\n· Mikrofon hanya digunakan untuk penilaian pelafalan. Jika kamu menolaknya, semua fitur lain tetap berfungsi.\n\n· Pembayaran dilakukan melalui pembelian dalam aplikasi App Store, dan aplikasi tidak pernah melihat detail kartumu.';

  @override
  String get termsBody =>
      '· Penggunaan Hangul Bricks diatur oleh EULA standar Apple dan Ketentuan Layanan web kami.\n\n· Seumur hidup: Pembayaran sekali — tanpa langganan, tanpa perpanjangan.\n\n· Paket bulanan diperpanjang secara otomatis dengan harga yang sama kecuali dibatalkan setidaknya 24 jam sebelum periode berakhir.\n\n· Batalkan selama uji coba gratis dan kamu tidak akan dikenai biaya.';
}
