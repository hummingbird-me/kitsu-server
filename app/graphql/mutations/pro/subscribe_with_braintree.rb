class Mutations::Pro::SubscribeWithBraintree < Mutations::BaseMutation
  argument :tier, Types::ProTier,
    required: false,
    description: 'The tier to subscribe to'
  argument :nonce, String,
    required: false,
    description: 'The payment method nonce provided by the Braintree Client SDK'

  payload_type Types::ProSubscription

  def ready?
    raise GraphQL::ExecutionError, 'Must be logged in' if user.blank?

    true
  end

  def resolve(tier:, nonce:)

    Pro::SubscribeWithBraintree.call(user: user, tier: tier, nonce: nonce)
  rescue Net::ReadTimeout, Braintree::DownForMaintenanceError
    raise GraphQL::ExecutionError, 'Connection to Braintree timed out'
  rescue Braintree::ServerError, Braintree::SSLCertificateError, Braintree::UnexpectedError,
         Braintree::AuthenticationError, Braintree::ConfigurationError
    raise GraphQL::ExecutionError, 'Something went wrong when connecting to Braintree'
  end

  private

  def user
    context[:user]
  end
end
