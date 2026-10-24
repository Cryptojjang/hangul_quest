// Creates a Lemon Squeezy checkout for the chosen plan.
// POST {plan: "lifetime" | "monthly" | "yearly"} → {url}  (opened in the
// Lemon.js overlay). "lifetime" is a single-payment variant.
const { env, ls } = require('./_lib/lemonsqueezy');

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
  try {
    const asked = req.body && req.body.plan;
    const plan =
      asked === 'monthly' ? 'monthly'
      : asked === 'yearly' && e.variantYearly ? 'yearly'
      : 'lifetime';
    const variant =
      plan === 'monthly' ? e.variantMonthly
      : plan === 'yearly' ? e.variantYearly
      : e.variantLifetime;
    const origin = req.headers.origin || `https://${req.headers.host}`;

    const body = await ls(e.apiKey, '/checkouts', {
      method: 'POST',
      body: JSON.stringify({
        data: {
          type: 'checkouts',
          attributes: {
            checkout_options: { embed: true },
            product_options: { redirect_url: `${origin}/` },
          },
          relationships: {
            store: { data: { type: 'stores', id: String(e.storeId) } },
            variant: { data: { type: 'variants', id: String(variant) } },
          },
        },
      }),
    });
    res.status(200).json({ url: body.data.attributes.url });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
