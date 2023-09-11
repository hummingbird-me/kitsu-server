# frozen_string_literal: true

class GraphqlController < ApplicationController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      token: current_user,
      user: current_user&.resource_owner,
      accept_languages:
    }
    result = KitsuSchema.execute(query,
      variables:,
      context:,
      operation_name:)
    render json: result
  rescue StandardError => e
    handle_error(e)
  end

  private

  def accept_languages
    PreferredLocale::HeaderParser.new(request.env['HTTP_ACCEPT_LANGUAGE']).preferred_locales
  end

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
    Sentry.capture_exception(exception, {})

    logger.error exception.message
    logger.error exception.backtrace.join("\n")

    render json: {
      error: {
        message: exception.message,
        backtrace: (exception.backtrace if Rails.env.development?)
      }.compact,
      data: {}
    }, status: :internal_server_error
  end
end
