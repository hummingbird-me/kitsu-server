class Mutations::Pro::SubscribeWithStripe < Mutations::Base
  behind_feature_flag :pro_subscriptions

  argument :tier, Types::Enum::ProTier,
    required: true,
    description: 'The tier to subscribe to'
  argument :token, String,
    required: true,
    description: 'The payment method token provided by Stripe.js'

  payload_type Types::ProSubscription

  def ready?
    raise GraphQL::ExecutionError, ErrorI18n.t(NotLoggedInError) if user.blank?

    true
  end

  def resolve(tier:, token:)
    Pro::SubscribeWithStripe.call(user: user, tier: tier, token: token).subscription
  rescue Stripe::StripeError => ex
    raise GraphQL::ExecutionError, ErrorI18n.t(ex)
  end

  private

  def user
    context[:user]
  end
end
