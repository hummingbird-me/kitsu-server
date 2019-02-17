class Mutations::Pro::GiftWithBraintree < Mutations::BaseMutation
  argument :tier, Types::ProTier,
    required: true,
    description: 'The tier to give a gift of'
  argument :nonce, String,
    required: true,
    description: 'The payment method nonce provided by the Braintree Client SDK'
  argument :target_user_id, ID,
    required: true,
    description: 'The user to give a gift to'
  argument :message, String,
    required: false,
    description: 'A message to include with your gift'

  payload_type Types::ProGift

  def ready?
    raise GraphQL::ExecutionError, ErrorI18n.t(NotLoggedInError) if user.blank?

    true
  end

  def resolve(tier:, nonce:, target_user_id:, message: nil)
    Pro::GiftWithBraintree.call(
      from: user,
      to: target_user_id,
      tier: tier,
      nonce: nonce,
      message: message
    )
  rescue Net::ReadTimeout
    raise GraphQL::ExecutionError, ErrorI18n.t(Braintree::BraintreeError)
  rescue Braintree::BraintreeError, ProError => ex
    raise GraphQL::ExecutionError, ErrorI18n.t(ex)
  end

  private

  def user
    context[:user]
  end
end
