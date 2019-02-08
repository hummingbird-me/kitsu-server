class Types::MutationType < Types::BaseObject
  # Kitsu Pro
  field :pro_subscribe_with_braintree,
    mutation: Mutations::Pro::SubscribeWithBraintree,
    description: 'Subscribe to Pro using Braintree'
  field :pro_subscribe_with_stripe,
    mutation: Mutations::Pro::SubscribeWithStripe,
    description: 'Subscribe to Pro using Stripe'
  field :pro_unsubscribe,
    mutation: Mutations::Pro::Unsubscribe,
    description: "End the users' pro subscription"
end
