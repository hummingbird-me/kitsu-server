# frozen_string_literal: true

class SentryTracing
  def self.trace(key, data)
    if key.start_with?('execute_query')
      # Set the transaction name based on the operation type and name
      selected_op = data[:query].selected_operation
      if selected_op
        op_type = selected_op.operation_type
        op_name = selected_op.name || 'anonymous'
      else
        op_type = 'query'
        op_name = 'anonymous'
      end

      Sentry.with_scope do
        Sentry.set_transaction_name("GraphQL/#{op_type}.#{op_name}")
        yield
      end
    else
      yield
    end
  end
end
