// Public runtime config for the web client. When STRIPE_SECRET_KEY is not
// set on the deployment, the app runs its clearly-labeled demo checkout.
module.exports = (req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  res.status(200).json({
    stripeEnabled: Boolean(
      process.env.STRIPE_SECRET_KEY &&
        process.env.STRIPE_PRICE_YEARLY &&
        process.env.STRIPE_PRICE_MONTHLY,
    ),
  });
};
