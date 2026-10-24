// Public runtime config for the web client. When the Lemon Squeezy env vars
// are not all set on the deployment, the app runs its clearly-labeled demo
// checkout.
module.exports = (req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  res.status(200).json({
    paymentsEnabled: Boolean(
      process.env.LEMONSQUEEZY_API_KEY &&
        process.env.LEMONSQUEEZY_STORE_ID &&
        process.env.LEMONSQUEEZY_VARIANT_LIFETIME &&
        process.env.LEMONSQUEEZY_VARIANT_MONTHLY,
    ),
  });
};
