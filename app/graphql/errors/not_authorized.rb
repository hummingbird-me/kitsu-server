class Errors::NotAuthorized < GraphQL::ExecutionError
  def to_h
    super.merge({ extensions: { code: Errors::Codes::NOT_AUTHORIZED } })
  end
end
