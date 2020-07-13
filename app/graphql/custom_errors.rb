module GraphQL
  module Execution
    class Errors
      def with_error_handling(_ctx)
        yield
      rescue StandardError => e
        klass = "Errors::#{e.class}".safe_constantize

        if klass&.respond_to?(:graphql_error)
          klass.graphql_error(e)
        else
          {
            errors: [
              {
                message: e.message,
                code: e.class.to_s
              }
            ]
          }
        end
      end
    end
  end
end
