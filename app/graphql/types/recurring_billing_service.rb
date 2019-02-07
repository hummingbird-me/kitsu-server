class Types::RecurringBillingService < Types::BaseEnum
  value 'STRIPE', 'Bill a credit card via Stripe', value: 'stripe'
  value 'BRAINTREE', 'Bill a PayPal account via Braintree', value: 'braintree'
  value 'APPLE', 'Billed through Apple In-App Subscription', value: 'apple_ios'
  value 'GOOGLE_PLAY', 'Billed through Google Play Subscription', value: 'google_play'
end
