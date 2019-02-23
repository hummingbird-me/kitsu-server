class Types::RecurringBillingService < Types::BaseEnum
  value 'STRIPE', 'Bill a credit card via Stripe', value: 'stripe'
  value 'PAYPAL', 'Bill a PayPal account', value: 'paypal'
  value 'APPLE', 'Billed through Apple In-App Subscription', value: 'apple_ios'
  value 'GOOGLE_PLAY', 'Billed through Google Play Subscription', value: 'google_play'
end
