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
    description: "End the user's pro subscription"
  field :pro_set_message,
    mutation: Mutations::Pro::SetMessage,
    description: "Set the user's pro message"
  field :pro_set_discord,
    mutation: Mutations::Pro::SetDiscord,
    description: "Set the user's discord tag"
end
