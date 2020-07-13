module Errors
  module ActiveRecord
    class RecordNotFound
      def self.graphql_error(err)
        {
          errors: [
            {
              message: err.message,
              code: err.class.to_s
            }
          ]
        }
      end
    end
  end
end
