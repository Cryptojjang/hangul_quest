// node --test test/api — exercises the /api functions against a stubbed
// fetch (Lemon Squeezy + Resend), no network.
const test = require('node:test');
const assert = require('node:assert');

const restoreEmail = require('../../api/restore-email');
const verify = require('../../api/verify');

const ENV = {
  LEMONSQUEEZY_API_KEY: 'k',
  LEMONSQUEEZY_STORE_ID: '7',
  LEMONSQUEEZY_VARIANT_LIFETIME: '100',
  LEMONSQUEEZY_VARIANT_MONTHLY: '200',
  RESTORE_SECRET: 'test-secret',
  RESEND_API_KEY: 're_test',
  RESTORE_EMAIL_FROM: 'Hangul Bricks <restore@example.com>',
};

const order = (id, email, variant, extra = {}) => ({
  id: String(id),
  attributes: {
    identifier: `uuid-${id}`,
    store_id: 7,
    user_email: email,
    status: 'paid',
    refunded: false,
    first_order_item: { variant_id: variant },
    ...extra,
  },
});

// orders/subs: what Lemon Squeezy "has"; filtering by email mimics the API
// (case-insensitive unless caseSensitive) unless ignoreFilter simulates a
// filter it drops.
function stub({ orders = [], subs = [], ignoreFilter = false, caseSensitive = false, resendOk = true } = {}) {
  const sent = [];
  globalThis.fetch = async (url, init = {}) => {
    const u = new URL(url);
    const json = (status, body) => ({ ok: status < 300, status, json: async () => body });
    if (u.host === 'api.resend.com') {
      sent.push(JSON.parse(init.body));
      return json(resendOk ? 200 : 500, {});
    }
    const raw = u.searchParams.get('filter[user_email]') || '';
    const norm = (v) => (caseSensitive ? v : v.toLowerCase());
    const pick = (rows) =>
      ignoreFilter ? rows : rows.filter((r) => norm(r.attributes.user_email) === norm(raw));
    if (u.pathname === '/v1/orders') return json(200, { data: pick(orders) });
    if (u.pathname === '/v1/subscriptions') {
      const orderId = u.searchParams.get('filter[order_id]');
      return json(200, {
        data: orderId ? subs.filter((s) => String(s.attributes.order_id) === orderId) : pick(subs),
      });
    }
    const one = orders.find((o) => u.pathname === `/v1/orders/${o.id}`);
    if (one) return json(200, { data: one });
    return json(404, { errors: [{ detail: 'not found' }] });
  };
  return sent;
}

async function call(handler, body, method = 'POST') {
  let status;
  let payload;
  const res = {
    status(s) { status = s; return this; },
    json(p) { payload = p; return this; },
  };
  await handler({ method, body, headers: {} }, res);
  return { status, body: payload };
}

const codeIn = (mail) => mail.text.match(/code: (\w{4})-(\w{4})/).slice(1).join('');

test.beforeEach(() => {
  Object.assign(process.env, ENV);
  restoreEmail.minReplyMs = 0;
});
test.afterEach(() => {
  for (const k of Object.keys(ENV)) delete process.env[k];
});

test('503 until the email provider and secret are configured', async () => {
  delete process.env.RESEND_API_KEY;
  stub();
  const r = await call(restoreEmail, { email: 'a@b.co' });
  assert.equal(r.status, 503);
});

test('rejects a missing or malformed email', async () => {
  stub();
  assert.equal((await call(restoreEmail, { email: 'nope' })).status, 400);
});

test('buyer and stranger get identical replies; only the buyer is mailed', async () => {
  const sent = stub({ orders: [order(1, 'Fan@Mail.com', 100)] });
  const buyer = await call(restoreEmail, { email: 'fan@mail.com' });
  const stranger = await call(restoreEmail, { email: 'who@mail.com' });

  assert.equal(buyer.status, 200);
  assert.deepEqual(Object.keys(buyer.body), Object.keys(stranger.body));
  assert.equal(buyer.body.sent, true);
  assert.equal(stranger.body.sent, true);
  assert.equal(sent.length, 1);
  assert.deepEqual(sent[0].to, ['fan@mail.com']);
});

test('a failed send still answers like any other email', async () => {
  stub({ orders: [order(1, 'fan@mail.com', 100)], resendOk: false });
  const origError = console.error;
  console.error = () => {};
  try {
    const r = await call(restoreEmail, { email: 'fan@mail.com' });
    assert.equal(r.status, 200);
    assert.equal(r.body.sent, true);
  } finally {
    console.error = origError;
  }
});

test('mailed code unlocks lifetime and returns the restore token', async () => {
  const sent = stub({ orders: [order(1, 'fan@mail.com', 100)] });
  const { body } = await call(restoreEmail, { email: 'fan@mail.com' });
  const code = codeIn(sent[0]);

  // Typed with a dash and lowercase still works.
  const r = await call(restoreEmail, {
    email: 'fan@mail.com',
    code: `${code.slice(0, 4).toLowerCase()}-${code.slice(4)}`,
    expires: body.expires,
  });
  assert.deepEqual(r.body, { isActive: true, plan: 'lifetime', inTrial: false, token: '1:uuid-1' });
});

test('wrong code, other email, or expired code unlocks nothing', async () => {
  const sent = stub({
    orders: [order(1, 'fan@mail.com', 100), order(2, 'other@mail.com', 100)],
  });
  const { body } = await call(restoreEmail, { email: 'fan@mail.com' });
  const code = codeIn(sent[0]);

  const wrong = await call(restoreEmail, { email: 'fan@mail.com', code: 'AAAAAAAA', expires: body.expires });
  assert.equal(wrong.body.isActive, false);
  assert.equal(wrong.body.invalidCode, true);

  const swapped = await call(restoreEmail, { email: 'other@mail.com', code, expires: body.expires });
  assert.equal(swapped.body.invalidCode, true);

  const realNow = Date.now;
  Date.now = () => body.expires + 1;
  try {
    const late = await call(restoreEmail, { email: 'fan@mail.com', code, expires: body.expires });
    assert.equal(late.body.invalidCode, true);
  } finally {
    Date.now = realNow;
  }
});

test('refunded lifetime orders are not mailed a code', async () => {
  const sent = stub({ orders: [order(1, 'fan@mail.com', 100, { refunded: true })] });
  await call(restoreEmail, { email: 'fan@mail.com' });
  assert.equal(sent.length, 0);
});

test('an active monthly subscription restores with its order token', async () => {
  const sent = stub({
    orders: [order(5, 'sub@mail.com', 200)],
    subs: [
      {
        id: '9',
        attributes: {
          store_id: 7,
          user_email: 'sub@mail.com',
          order_id: 5,
          variant_id: 200,
          status: 'active',
          renews_at: '2099-01-01T00:00:00Z',
        },
      },
    ],
  });
  const { body } = await call(restoreEmail, { email: 'sub@mail.com' });
  const r = await call(restoreEmail, { email: 'sub@mail.com', code: codeIn(sent[0]), expires: body.expires });
  assert.equal(r.body.isActive, true);
  assert.equal(r.body.plan, 'monthly');
  assert.equal(r.body.token, '5:uuid-5');
});

test('orders for other emails are ignored even if the API drops the filter', async () => {
  const sent = stub({ orders: [order(1, 'fan@mail.com', 100)], ignoreFilter: true });
  await call(restoreEmail, { email: 'who@mail.com' });
  assert.equal(sent.length, 0);
});

test('verify still resolves a lifetime token (shared helpers)', async () => {
  stub({ orders: [order(1, 'fan@mail.com', 100)] });
  const r = await call(verify, { token: '1:uuid-1' });
  assert.equal(r.body.isActive, true);
  assert.equal(r.body.plan, 'lifetime');
  const bad = await call(verify, { token: '1:wrong' });
  assert.equal(bad.body.isActive, false);
});

test('finds a lowercased checkout email when typed with capitals', async () => {
  const sent = stub({ orders: [order(1, 'fan@mail.com', 100)], caseSensitive: true });
  await call(restoreEmail, { email: 'Fan@Mail.com' });
  assert.equal(sent.length, 1);
});

test('mails the code in the app language, English for unknown ones', async () => {
  const sent = stub({ orders: [order(1, 'fan@mail.com', 100)] });
  await call(restoreEmail, { email: 'fan@mail.com', lang: 'ja' });
  await call(restoreEmail, { email: 'fan@mail.com', lang: '__proto__' });
  assert.match(sent[0].subject, /復元コード/);
  assert.match(sent[0].text, /\w{4}-\w{4}/);
  assert.equal(sent[1].subject, 'Your Hangul Bricks restore code');
});

test('a stranger waits the same minimum time as a buyer', async () => {
  stub();
  restoreEmail.minReplyMs = 60;
  const t = Date.now();
  await call(restoreEmail, { email: 'who@mail.com' });
  assert.ok(Date.now() - t >= 55);
});
