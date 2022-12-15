class Mutations::Account::UpdateAccount < Mutations::Base
  prepend RescueValidationErrors

  description 'Update account'

  argument :input,
    Types::Input::Account::UpdateAccount,
    required: true,
    description: 'Update account',
    as: :account

  field :account, Types::Account, null: true

  def load_account(value)
    raise GraphQL::ExecutionError, 'You must be authorized.' if current_token.blank?
    account = ::User.find(current_user.id)
    account.assign_attributes(value.to_h)
    account
  end

  def resolve(account:)
    account.save!

    { account: account }
  end
end
