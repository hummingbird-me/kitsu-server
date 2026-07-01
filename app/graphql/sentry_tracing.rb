# frozen_string_literal: true

module SentryTracing
  def execute_query(query:)
    trace_query(query) { super }
  end

  def execute_query_lazy(query:, multiplex:)
    trace_query(query) { super }
  end

  private

  def trace_query(query)
    selected_op = query&.selected_operation
    if selected_op
      op_type = selected_op.operation_type
      op_name = selected_op.name || 'anonymous'
    else
      op_type = 'query'
      op_name = 'anonymous'
    end

    Sentry.with_scope do
      Sentry.configure_scope do |scope|
        scope.set_transaction_name("GraphQL/#{op_type}.#{op_name}")
      end

      yield
    end
  end
end
