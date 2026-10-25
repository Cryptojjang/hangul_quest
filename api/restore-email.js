// Restores a web purchase on a new device without accounts: the buyer proves
// they own the checkout email by typing back a one-time code we mail them.
//
// POST {email} → {sent: true, expires}
//   Same answer whether or not the email bought anything, so this can't be
//   used to find out who is a customer. The code is only mailed when the
//   email has a live entitlement in this store.
// POST {email, code, expires} → verify.js shape ({isActive, plan, …, token})
//   or {isActive: false, invalidCode: true}. The token is the usual
//   "<orderId>:<identifier>" restore token, which the client keeps so later
//   restores on that device need no email.
//
// Stateless: the code is HMAC(RESTORE_SECRET, email + expires), so nothing is
// stored. 8 symbols from a 31-letter alphabet (~8.5e11 codes) keep guessing
// infeasible inside the 30-minute window without an attempt counter.
const crypto = require('crypto');
const { env, ls, NONE, statusFromSubscription } = require('./_lib/lemonsqueezy');

const TTL_MS = 30 * 60 * 1000;
const ALPHABET = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789'; // no 0/O, 1/I/L

function codeFor(secret, email, expires) {
  const mac = crypto
    .createHmac('sha256', secret)
    .update(`restore:${email.toLowerCase()}:${expires}`)
    .digest();
  let code = '';
  for (let i = 0; i < 8; i++) code += ALPHABET[mac[i] % ALPHABET.length];
  return code;
}

// Best entitlement for an email: a paid lifetime order, else a live
// subscription. The user_email check guards against the filter being ignored.
async function entitlementFor(e, email) {
  const key = email.toLowerCase();
  const mine = (a) =>
    String(a.store_id) === String(e.storeId) &&
    String(a.user_email || '').toLowerCase() === key;
  const q =
    `filter[store_id]=${e.storeId}` +
    `&filter[user_email]=${encodeURIComponent(email)}&page[size]=100`;

  const orders = (await ls(e.apiKey, `/orders?${q}`)).data.filter((o) =>
    mine(o.attributes),
  );
  const tokenOf = (o) => `${o.id}:${o.attributes.identifier}`;
  const lifetime = orders.find((o) => {
    const a = o.attributes;
    const item = a.first_order_item || {};
    return (
      String(item.variant_id) === String(e.variantLifetime) &&
      a.status === 'paid' &&
      !a.refunded
    );
  });
  if (lifetime) {
    return { isActive: true, plan: 'lifetime', inTrial: false, token: tokenOf(lifetime) };
  }

  const subs = (await ls(e.apiKey, `/subscriptions?${q}`)).data;
  for (const sub of subs) {
    if (!mine(sub.attributes)) continue;
    const order = orders.find((o) => String(o.id) === String(sub.attributes.order_id));
    if (!order) continue;
    const status = statusFromSubscription(sub, e, tokenOf(order));
    if (status.isActive) return status;
  }
  return null;
}

async function sendCode(to, code) {
  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${process.env.RESEND_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      from: process.env.RESTORE_EMAIL_FROM,
      to: [to],
      subject: 'Your Hangul Bricks restore code',
      text:
        `Your restore code: ${code.slice(0, 4)}-${code.slice(4)}\n\n` +
        'Enter it in Hangul Bricks (Restore with email) within 30 minutes ' +
        'to unlock Premium on that device.\n\n' +
        "If you didn't ask for this, you can ignore this email.",
    }),
  });
  if (!res.ok) throw new Error(`resend ${res.status}`);
}

function sameCode(a, b) {
  return a.length === b.length && crypto.timingSafeEqual(Buffer.from(a), Buffer.from(b));
}

module.exports = async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'method not allowed' });
    return;
  }
  const e = env();
  const secret = process.env.RESTORE_SECRET;
  if (!e || !secret || !process.env.RESEND_API_KEY || !process.env.RESTORE_EMAIL_FROM) {
    res.status(503).json({ error: 'email restore not configured' });
    return;
  }
  const body = req.body || {};
  const email = String(body.email || '').trim();
  if (email.length > 254 || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    res.status(400).json({ error: 'email required' });
    return;
  }

  try {
    if (body.code === undefined) {
      const expires = Date.now() + TTL_MS;
      const found = await entitlementFor(e, email);
      if (found) {
        try {
          await sendCode(email, codeFor(secret, email, expires));
        } catch (err) {
          // Answer as usual: a different reply here would reveal a buyer.
          console.error('restore-email send failed:', err.message);
        }
      }
      res.status(200).json({ sent: true, expires });
      return;
    }

    const expires = Number(body.expires);
    const code = String(body.code).toUpperCase().replace(/[^A-Z0-9]/g, '');
    if (!(expires > Date.now()) || !sameCode(code, codeFor(secret, email, expires))) {
      res.status(200).json({ ...NONE, invalidCode: true });
      return;
    }
    res.status(200).json((await entitlementFor(e, email)) || { ...NONE });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
