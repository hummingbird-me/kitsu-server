class Mutations::Pro::SubscribeWithBraintree < Mutations::BaseMutation
  argument :tier, Types::ProTier,
    required: false,
    description: 'The tier to subscribe to'
  argument :nonce, String,
    required: false,
    description: 'The payment method nonce provided by the Braintree Client SDK'

  payload_type Types::ProSubscription

  def ready?
    raise GraphQL::ExecutionError, ErrorI18n.t(NotLoggedInError) if user.blank?

    true
  end

  def resolve(tier:, nonce:)
    Pro::SubscribeWithBraintree.call(user: user, tier: tier, nonce: nonce)
  rescue Net::ReadTimeout
    raise GraphQL::ExecutionError, I18n.t('errors.braintree.braintree_error')
  rescue Braintree::BraintreeError => ex
    raise GraphQL::ExecutionError, ErrorI18n.t(ex)
  end

  private

  def user
    context[:user]
  end
end
