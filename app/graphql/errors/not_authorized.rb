class Errors::NotAuthorized < GraphQL::ExecutionError
  def initialize(message)
    super(message, extensions: {
      code: Errors::Codes::NOT_AUTHORIZED
    })
  end
end
