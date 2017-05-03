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
          # Capital letters tend to be chunks of unchanging SQL
          # Basically, a ghetto way to unify based on SQL similarity (lol)
          message = error.original_exception.error.scan(/[A-Z]/).join
          extra[:fingerprint] = [error.original_exception.class.name, message]
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
