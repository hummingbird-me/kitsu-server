module Errors::RecordNotFound
  def self.graphql_error(error)
    {
      errors: [
        {
          message: error.message,
          path: ['attributes', error.primary_key],
          extensions: {
            code: Errors::Codes::RECORD_NOT_FOUND
          }
        }
      ]
    }
  end
end
