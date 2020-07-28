# HACK: https://github.com/rmosolgo/graphql-ruby/blob/master/lib/graphql/execution/errors.rb
# MonkeyPatching this method so it always returns graphql errors as data
module GraphQL
  module Execution
    class Errors
      alias_method :original_with_error_handling, :with_error_handling

      def with_error_handling(ctx, &block)
        yield
      rescue StandardError => e
        return original_with_error_handling(ctx, &block) if ctx.query.query?

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
