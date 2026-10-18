// Verifies entitlement.
// POST {sessionId} (checkout return) or {customerId} (restore) →
//   {isActive, plan, inTrial, expiresAtMillis, customerId}
const Stripe = require('stripe');

const NONE = { isActive: false, inTrial: false };

function statusFromSubscription(sub, customerId) {
  if (!sub) return { ...NONE, customerId };
  const active = sub.status === 'active' || sub.status === 'trialing';
  const price = sub.items && sub.items.data[0] && sub.items.data[0].price;
  const plan =
    price && price.recurring && price.recurring.interval === 'year'
      ? 'yearly'
      : 'monthly';
  return {
    isActive: active,
    plan: active ? plan : undefined,
    inTrial: sub.status === 'trialing',
    expiresAtMillis: sub.current_period_end
      ? sub.current_period_end * 1000
      : undefined,
    customerId,
  };
}

module.exports = async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'method not allowed' });
    return;
  }
  const key = process.env.STRIPE_SECRET_KEY;
  if (!key) {
    res.status(503).json({ error: 'stripe not configured' });
    return;
  }
  try {
    const stripe = Stripe(key);
    const { sessionId, customerId } = req.body || {};

    if (sessionId) {
      const session = await stripe.checkout.sessions.retrieve(sessionId, {
        expand: ['subscription'],
      });
      res
        .status(200)
        .json(statusFromSubscription(session.subscription, session.customer));
      return;
    }

    if (customerId) {
      const subs = await stripe.subscriptions.list({
        customer: customerId,
        status: 'all',
        limit: 5,
      });
      const best =
        subs.data.find((s) => s.status === 'active' || s.status === 'trialing') ||
        subs.data[0];
      res.status(200).json(statusFromSubscription(best, customerId));
      return;
    }

    res.status(400).json({ error: 'sessionId or customerId required' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
