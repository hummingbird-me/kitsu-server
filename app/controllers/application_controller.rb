# frozen_string_literal: true

class ApplicationController < JSONAPI::ResourceController
  include PreferredLocale::AutoLocale
  include DoorkeeperHelpers
  include Pundit::ResourceController

  before_action :validate_token!
  before_action :tag_sentry_context

  around_action :store_user_on_thread
  around_action :store_region_on_thread
  around_action :flush_buffered_feeds

  def base_url
    "#{super}/api/edge"
  end

  # TODO: get rid of this dumb hack for pundit-resources
  def enforce_policy_use(*); end

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

  private

  # Verifies the Cloudflare Turnstile token sent from the frontend client
  def valid_captcha?(captcha_token)
    secret_key = ENV.fetch('TURNSTILE_SECRET_KEY', nil)
    return true if (secret_key.nil? || secret_key.strip.empty?) && !Rails.env.production?
    return false if captcha_token.nil? || captcha_token.strip.empty?

    response = HTTP.post('https://challenges.cloudflare.com/turnstile/v0/siteverify', form: {
      secret: secret_key,
      response: captcha_token,
      remoteip: request.remote_ip
    })

    response.parse['success'] == true
  rescue StandardError => e
    Sentry.capture_exception(e) if defined?(Sentry)
    false
  end
end
