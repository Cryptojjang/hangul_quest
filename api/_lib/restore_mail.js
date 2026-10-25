// Restore-code email in the app's UI language (lib/l10n locale codes).
// {code} is the formatted code; the button name matches restoreEmailAction.
const MAIL = {
  en: {
    subject: 'Your Hangul Bricks restore code',
    body: 'Your restore code: {code}\n\nEnter it in Hangul Bricks (Restore with email) within 30 minutes to unlock Premium on that device.\n\nIf you didn\'t ask for this, you can ignore this email.',
  },
  de: {
    subject: 'Dein Wiederherstellungscode für Hangul Bricks',
    body: 'Dein Wiederherstellungscode: {code}\n\nGib ihn innerhalb von 30 Minuten in Hangul Bricks (Per E-Mail wiederherstellen) ein, um Premium auf diesem Gerät freizuschalten.\n\nWenn du das nicht angefordert hast, kannst du diese E-Mail ignorieren.',
  },
  es: {
    subject: 'Tu código para restaurar Hangul Bricks',
    body: 'Tu código de restauración: {code}\n\nIntrodúcelo en Hangul Bricks (Restaurar con email) en los próximos 30 minutos para desbloquear Premium en ese dispositivo.\n\nSi no lo pediste, puedes ignorar este email.',
  },
  fr: {
    subject: 'Ton code de restauration Hangul Bricks',
    body: 'Ton code de restauration : {code}\n\nSaisis-le dans Hangul Bricks (Restaurer par e-mail) dans les 30 minutes pour débloquer Premium sur cet appareil.\n\nSi tu n\'as rien demandé, ignore cet e-mail.',
  },
  id: {
    subject: 'Kode pemulihan Hangul Bricks kamu',
    body: 'Kode pemulihanmu: {code}\n\nMasukkan di Hangul Bricks (Pulihkan dengan email) dalam 30 menit untuk membuka Premium di perangkat itu.\n\nJika kamu tidak memintanya, abaikan email ini.',
  },
  ja: {
    subject: 'Hangul Bricks 復元コード',
    body: '復元コード：{code}\n\n30分以内に Hangul Bricks の「メールで復元」に入力すると、その端末でプレミアムが使えるようになります。\n\nお心当たりがない場合は、このメールを無視してください。',
  },
  pt: {
    subject: 'Seu código de restauração do Hangul Bricks',
    body: 'Seu código de restauração: {code}\n\nDigite-o no Hangul Bricks (Restaurar por e-mail) em até 30 minutos para desbloquear o Premium nesse dispositivo.\n\nSe você não pediu isso, pode ignorar este e-mail.',
  },
  th: {
    subject: 'รหัสกู้คืน Hangul Bricks ของคุณ',
    body: 'รหัสกู้คืนของคุณ: {code}\n\nกรอกรหัสใน Hangul Bricks (กู้คืนด้วยอีเมล) ภายใน 30 นาทีเพื่อปลดล็อก Premium บนอุปกรณ์นั้น\n\nหากคุณไม่ได้ขอรหัสนี้ ไม่ต้องสนใจอีเมลนี้',
  },
  vi: {
    subject: 'Mã khôi phục Hangul Bricks của bạn',
    body: 'Mã khôi phục của bạn: {code}\n\nNhập mã trong Hangul Bricks (Khôi phục bằng email) trong vòng 30 phút để mở khóa Premium trên thiết bị đó.\n\nNếu bạn không yêu cầu, hãy bỏ qua email này.',
  },
  zh: {
    subject: '你的 Hangul Bricks 恢复验证码',
    body: '你的恢复验证码：{code}\n\n请在 30 分钟内于 Hangul Bricks 的“通过邮箱恢复”中输入，即可在该设备上解锁高级版。\n\n如果这不是你本人的操作，请忽略此邮件。',
  },
  zh_TW: {
    subject: '你的 Hangul Bricks 恢復驗證碼',
    body: '你的恢復驗證碼：{code}\n\n請在 30 分鐘內於 Hangul Bricks 的「透過電子郵件恢復」中輸入，即可在該裝置上解鎖 Premium。\n\n如果這不是你本人的操作，請忽略此郵件。',
  },
};

function restoreMail(lang, code) {
  const m = Object.hasOwn(MAIL, lang) ? MAIL[lang] : MAIL.en;
  return { subject: m.subject, text: m.body.replace('{code}', `${code.slice(0, 4)}-${code.slice(4)}`) };
}

module.exports = { restoreMail };
