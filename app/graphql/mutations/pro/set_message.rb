class Mutations::Pro::SetMessage < Mutations::BaseMutation
  argument :message, String,
    required: true,
    description: 'The message to set for your Hall of Fame entry'

  field :message, String, null: false

  def ready?
    # Check that we're logged in
    raise GraphQL::ExecutionError, ErrorI18n.t(NotLoggedInError) if user.blank?

    true
  end

  def resolve(message:)
    Pro::SetMessage.call(
      user: User.current,
      message: message
    )

    { message: message }
  rescue NotAuthorizedError => ex
    raise GraphQL::ExecutionError, ErrorI18n.t(ex)
  end
end
