class Mutations::Account < Mutations::Namespace
  field :send_password_reset,
    mutation: Mutations::Account::SendPasswordReset,
    description: 'Send a password reset email'

  field :update,
    mutation: Mutations::Account::Update,
    description: 'Update the profile and account of the current user.'

  field :update_account,
    mutation: Mutations::Account::UpdateAccount,
    description: 'Update the account of the current user.'
end
