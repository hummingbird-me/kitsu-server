# frozen_string_literal: true

class ApplicationController < JSONAPI::ResourceController
  include PreferredLocale::AutoLocale
  include DoorkeeperHelpers
  include Pundit::ResourceController

  def base_url
    super + '/api/edge'
  end

  # HACK: JSONAPI::Resources compares request.content_type, which includes parameters such as
  # the charset from Rails 7.1 onwards
  def verify_content_type_header
    request.media_type == JSONAPI::MEDIA_TYPE || super
  end

  # TODO: get rid of this dumb hack for pundit-resources
  def enforce_policy_use(*); end

  before_action :validate_token!
  around_action :store_user_on_thread
  around_action :store_region_on_thread
  around_action :flush_buffered_feeds

  def flush_buffered_feeds
    yield
  ensure
    Feed.client.try(:flush_async)
  end

  def store_region_on_thread
    Thread.current[:region] = request.headers['CF-IPCountry']
    begin
      yield
    ensure
      Thread.current[:region] = nil
    end
  end

  rescue_from Strait::RateLimitExceeded do
    render status: :too_many_requests, json: {
      errors: [{
        status: 429,
        title: 'Rate Limit Exceeded'
      }]
    }
  end

  on_server_error do |error|
    next unless Sentry.configuration.sending_allowed?

    Sentry.capture_exception(error)
  end

  before_action :tag_sentry_context

  def tag_sentry_context
    user = current_user&.resource_owner
    Sentry.set_user(
      id: user&.id,
      name: user&.name,
      ip_address: request.remote_ip
    )
    Sentry.configure_scope do |scope|
      scope.set_context(
        'feature flags',
        Flipper.preload_all.to_h { |f| [f.name, f.enabled?(user)] }
      )
    end
  end

  def context
    {
      current_user:,
      remote_ip: request.remote_ip
    }
  end
end
