class Mutations::Pro::SubscribeWithStripe < Mutations::BaseMutation
  behind_feature_flag :pro_subscriptions

  argument :tier, Types::ProTier,
    required: true,
    description: 'The tier to subscribe to'
  argument :token, String,
    required: true,
    description: 'The payment method token provided by Stripe.js'

  payload_type Types::ProSubscription

  def ready?
    raise GraphQL::ExecutionError, 'Must be logged in' if user.blank?

    true
  end

  def resolve(tier:, token:)
    Pro::SubscribeWithStripe.call(user: user, tier: tier, token: token).subscription
  rescue Stripe::CardError
    raise GraphQL::ExecutionError, 'Invalid card'
  rescue Stripe::APIConnectionError
    raise GraphQL::ExecutionError, 'Failed to connect to credit card processor'
  rescue Stripe::StripeError
    raise GraphQL::ExecutionError, 'Something went wrong with our credit card processor'
  end

  private

  def user
    context[:user]
  end
end
