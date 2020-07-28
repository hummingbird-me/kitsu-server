module Errors
  module Pundit
    class NotAuthorizedError
      DEFAULT_MESSAGE = 'You are not authorized to perform this action.'.freeze

      def self.graphql_error(message = DEFAULT_MESSAGE)
        {
          errors: [
            {
              message: message,
              code: 'Pundit::NotAuthorizedError'
            }
          ]
        }
      end
    end
  end
end
