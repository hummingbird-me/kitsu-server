class ApplicationController < JSONAPI::ResourceController
  include DoorkeeperHelpers
  include Pundit::ResourceController
  include MaintainIpAddresses

  def base_url
    super + '/api/edge'
  end

  before_action :validate_token!

  force_ssl if Rails.env.production?

  if Raven.configuration.capture_allowed?
    on_server_error do |error|
      extra = {}
      begin
        if error.is_a?(ActiveRecord::StatementInvalid)
          # Clean the stack trace and use that for the fingerprint.
          trace = Rails.backtrace_cleaner.clean(error.backtrace)
          trace = trace.map { |line| line.split(/:\d+:/).first }
          extra[:fingerprint] = [error.original_exception.class.name, *trace]
        end
      ensure
        Raven.capture_exception(error, extra)
      end
    end

    before_action :tag_sentry_context

    def tag_sentry_context
      user = current_user&.resource_owner
      Raven.user_context(id: user.id, name: user.name) if user
      Raven.extra_context(url: request.url)
    end
  end
end
