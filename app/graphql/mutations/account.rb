class Mutations::Account < Mutations::Namespace
  field :send_password_reset,
    mutation: Mutations::Account::SendPasswordReset,
    description: 'Send a password reset email'
end
