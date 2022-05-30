class Mutations::Pro::SetDiscord < Mutations::Base
  argument :discord, String,
    required: true,
    description: 'Your discord tag (Name#1234)'

  field :discord, String, null: false

  def ready?
    # Check that we're logged in
    raise GraphQL::ExecutionError, ErrorI18n.t(NotLoggedInError) if user.blank?

    true
  end

  def resolve(discord:)
    Pro::SetDiscord.call(
      user: User.current,
      discord: discord
    )

    { discord: discord }
  rescue NotAuthorizedError => e
    raise GraphQL::ExecutionError, ErrorI18n.t(e)
  end
end
