class Mutations::Pro::GiftWithBraintree < Mutations::BaseMutation
  behind_feature_flag :pro_gifts

  argument :length, Types::ProGiftLength,
    required: true,
    description: 'How generous of a gift to give'
  argument :nonce, String,
    required: true,
    description: 'The payment method nonce provided by the Braintree Client SDK'
  argument :target_user_id, ID,
    as: :to,
    required: true,
    description: 'The user to gift pro to'
  argument :message, String,
    required: false,
    description: 'The message to include with this gift'

  payload_type Types::ProGift

  def ready?
    raise GraphQL::ExecutionError, 'Must be logged in' if user.blank?

    true
  end

  def resolve(**params)
    Pro::GiftWithBraintree.call(**params, from: context[:user]).gift
  rescue ActiveRecord::RecordNotFound
    raise GraphQL::ExecutionError, 'Recipient not found'
  rescue StandardError => e
    Raven.capture_exception(e)
    raise GraphQL::ExecutionError, ErrorI18n.t(e)
  end
end
