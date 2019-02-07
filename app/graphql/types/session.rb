class Types::Session < Types::BaseObject
  description 'Information about a user session'

  field :account, Types::Account,
    null: true,
    description: 'The account associated with this session'

  def account
    object unless object.blank?
  end

  field :profile, Types::Profile,
    null: true,
    description: 'The profile associated with this session'

  def profile
    object unless object.blank?
  end

  field :braintree_client_token, String,
    null: false,
    description: 'The token for the Braintree Client SDK'

  def braintree_client_token
    $braintree.client_token.generate
  end
end
