class GraphqlController < ApplicationController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = { token: current_user, user: current_user&.resource_owner }
    result = KitsuSchema.execute(query,
      variables: variables,
      context: context,
      operation_name: operation_name)
    render json: result
  rescue StandardError => error
    handle_error(error)
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def handle_error(exception)
    Raven.capture_exception(exception, {})

    logger.error exception.message
    logger.error exception.backtrace.join("\n")

    render json: {
      error: {
        message: exception.message,
        backtrace: (exception.backtrace if Rails.env.development?)
      }.compact,
      data: {}
    }, status: 500
  end
end
