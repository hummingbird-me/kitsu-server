class Errors::RecordNotFound < GraphQL::ExecutionError
  def initialize(message)
    super(message, extensions: {
      code: Errors::Codes::RECORD_NOT_FOUND
    })
  end
end
