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

  field :nolt_token, String,
    null: false,
    description: 'Single sign-on token for Nolt'

  def nolt_token
    user = context[:user]
    raise GraphQL::ExecutionError, 'You must be logged in to do that' if user.blank?

    Accounts::GenerateNoltToken.call(user: user).token
  end
end
