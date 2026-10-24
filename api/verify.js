// Verifies entitlement for a Lemon Squeezy order.
// POST {token: "<orderId>:<orderIdentifier>"} →
//   {isActive, plan, inTrial, expiresAtMillis, token}
//
// The token comes from the Lemon.js Checkout.Success event and is kept by the
// client for restore(). Order ids are sequential, so the order's UUID
// identifier must match too — a guessed id alone unlocks nothing.
const { env, ls } = require('./_lib/lemonsqueezy');

const NONE = { isActive: false, inTrial: false };
const LIVE = new Set(['on_trial', 'active', 'past_due']);

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

module.exports = async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'method not allowed' });
    return;
  }
  const e = env();
  if (!e) {
    res.status(503).json({ error: 'payments not configured' });
    return;
  }
  const token = String((req.body && req.body.token) || '');
  const [orderId, identifier] = token.split(':');
  if (!/^\d+$/.test(orderId || '') || !identifier) {
    res.status(400).json({ error: 'token required' });
    return;
  }
  try {
    const order = await ls(e.apiKey, `/orders/${orderId}`);
    const o = order.data.attributes;
    if (o.identifier !== identifier || String(o.store_id) !== String(e.storeId)) {
      res.status(200).json({ ...NONE });
      return;
    }
    // One-time lifetime unlock: a paid, non-refunded order for the lifetime
    // variant grants premium with no expiry.
    const item = o.first_order_item || {};
    if (String(item.variant_id) === String(e.variantLifetime)) {
      const active = o.status === 'paid' && !o.refunded;
      res.status(200).json({
        isActive: active,
        plan: active ? 'lifetime' : undefined,
        inTrial: false,
        token,
      });
      return;
    }
    const subs = await ls(
      e.apiKey,
      `/subscriptions?filter[store_id]=${e.storeId}&filter[order_id]=${orderId}`,
    );
    res.status(200).json(statusFromSubscription(subs.data[0], e, token));
  } catch (err) {
    if (err.status === 404) {
      res.status(200).json({ ...NONE });
      return;
    }
    res.status(500).json({ error: err.message });
  }
};
