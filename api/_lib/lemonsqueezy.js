// Minimal Lemon Squeezy REST client (JSON:API) shared by the /api functions.
// Uses the runtime's global fetch, so no SDK dependency.
const BASE = 'https://api.lemonsqueezy.com/v1';

function env() {
  const e = {
    apiKey: process.env.LEMONSQUEEZY_API_KEY,
    storeId: process.env.LEMONSQUEEZY_STORE_ID,
    // One-time "lifetime" unlock (single payment variant) + monthly
    // subscription. Yearly is optional and kept only for legacy orders.
    variantLifetime: process.env.LEMONSQUEEZY_VARIANT_LIFETIME,
    variantMonthly: process.env.LEMONSQUEEZY_VARIANT_MONTHLY,
    variantYearly: process.env.LEMONSQUEEZY_VARIANT_YEARLY || null,
  };
  return e.apiKey && e.storeId && e.variantLifetime && e.variantMonthly ? e : null;
}

async function ls(apiKey, path, init = {}) {
  const res = await fetch(`${BASE}${path}`, {
    ...init,
    headers: {
      Accept: 'application/vnd.api+json',
      'Content-Type': 'application/vnd.api+json',
      Authorization: `Bearer ${apiKey}`,
    },
  });
  const body = await res.json().catch(() => ({}));
  if (!res.ok) {
    const detail = body.errors && body.errors[0] && body.errors[0].detail;
    const err = new Error(detail || `lemonsqueezy ${res.status}`);
    err.status = res.status;
    throw err;
  }
  return body;
}

const NONE = { isActive: false, inTrial: false };
const LIVE = new Set(['on_trial', 'active', 'past_due']);

// verify.js response shape for a subscription (or NONE when there is none).
function statusFromSubscription(sub, e, token) {
  if (!sub) return { ...NONE, token };
  const a = sub.attributes;
  const endsAt = a.ends_at ? Date.parse(a.ends_at) : null;
  // A cancelled subscription keeps access until the paid period ends.
  const active =
    LIVE.has(a.status) || (a.status === 'cancelled' && endsAt > Date.now());
  const expires =
    endsAt ||
    (a.status === 'on_trial' && a.trial_ends_at && Date.parse(a.trial_ends_at)) ||
    (a.renews_at && Date.parse(a.renews_at)) ||
    undefined;
  return {
    isActive: active,
    plan: active
      ? String(a.variant_id) === String(e.variantYearly)
        ? 'yearly'
        : 'monthly'
      : undefined,
    inTrial: a.status === 'on_trial',
    expiresAtMillis: expires,
    token,
  };
}

module.exports = { env, ls, NONE, statusFromSubscription };
