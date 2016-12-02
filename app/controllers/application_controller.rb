class ApplicationController < JSONAPI::ResourceController
  include DoorkeeperHelpers
  include Pundit::ResourceController
  include MaintainIpAddresses

  def base_url
    super + '/api/edge'
  end

  before_action :validate_token!

  force_ssl if Rails.env.production?

  on_server_error { |error| Raven.capture_exception(error) }

  before_action :tag_sentry_context

  def tag_sentry_context
    Raven.user_context(id: current_user.resource_owner_id)
    Raven.extra_context(url: request.url)
  end
end
