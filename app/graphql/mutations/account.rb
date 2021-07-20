class Mutations::Account < Mutations::Namespace
  field :reset_password,
    mutation: Mutations::Account::ResetPassword,
    description: 'Send a password reset email'
end
