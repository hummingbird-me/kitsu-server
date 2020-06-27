class Errors::RecordNotFound < GraphQL::ExecutionError
  def to_h
    super.merge({ extensions: { code: Errors::Codes::RECORD_NOT_FOUND } })
  end
end
