class Mutations::Pro::SubscribeWithBraintree < Mutations::BaseMutation
  argument :plan, Types::ProMembershipPlan,
    null: false,
    description: 'The plan to subscribe to'
  argument :nonce, String,
    null: false,
    description: 'The payment method nonce provided by the Braintree Client SDK'

  payload_type Types::ProSubscription

  def ready?
    raise GraphQL::ExecutionError, 'Must be logged in' if user.blank?

    true
  end

  def resolve(plan:, nonce:)
    $braintree.customer.update(user.braintree_customer.id, payment_method_nonce: nonce)

    ProSubscription::BraintreeSubscription.create!(user: user, plan: plan)
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
