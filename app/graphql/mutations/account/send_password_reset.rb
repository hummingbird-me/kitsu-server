class Mutations::Account::SendPasswordReset < Mutations::Base
  include PublicMutation
  include RateLimitedMutation

  rate_limit do
    limit 5, per: 24.hours
  end

  argument :email, String,
    required: true,
    description: 'The email address to reset the password for'

  field :email, String, null: false

  def resolve(email:)
    Accounts::SendPasswordReset.call(email: email)

    { email: email }
  end
end
