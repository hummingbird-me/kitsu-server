class Mutations::Pro::SetMessage < Mutations::BaseMutation
  argument :message, String,
    required: true,
    description: 'The message to set for your Hall of Fame entry'

  def ready?
    # Check that we're logged in
    raise GraphQL::ExecutionError, ErrorI18n.t(NotLoggedInError) if user.blank?
    # Check that we're a Patron
    raise GraphQL::ExecutionError, ErrorI18n.t(NotAuthorizedError) unless user.patron?
    # Check that we haven't already set a message
    raise GraphQL::ExecutionError, ErrorI18n.t(NotAuthorizedError) unless user.pro_message.blank?

    true
  end

  def resolve(message:)
    User.current.update(pro_message: message)
  end
end
