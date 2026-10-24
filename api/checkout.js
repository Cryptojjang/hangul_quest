// Creates a Lemon Squeezy checkout for the chosen plan. The 7-day free trial
// is configured on each subscription variant in the Lemon Squeezy dashboard.
// POST {plan: "yearly" | "monthly"} → {url}  (opened in the Lemon.js overlay)
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
    const plan = (req.body && req.body.plan) === 'monthly' ? 'monthly' : 'yearly';
    const variant = plan === 'monthly' ? e.variantMonthly : e.variantYearly;
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
