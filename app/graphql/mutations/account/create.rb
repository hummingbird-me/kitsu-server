class Mutations::Account::Create < Mutations::Base
  include PublicMutation
  include RateLimitedMutation
  include FancyMutation

  description 'Create a new Kitsu account'

  rate_limit do
    limit 20, per: 1.hour
    limit 20, per: 2.days
  end

  input do
    argument :name, String,
      required: true,
      description: 'The name of the user'

    argument :email, String,
      required: true,
      description: 'The email address to reset the password for'

    argument :password, String,
      required: true,
      description: 'The password for the user'

    argument :external_identity, Types::Input::Account::ExternalIdentity,
      required: false,
      description: 'An external identity to associate with the account on creation'
  end
  result Types::Account

  def resolve(input:)
    AccountMutator.create(**input)
  end
end
