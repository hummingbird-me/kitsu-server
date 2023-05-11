# frozen_string_literal: true

Sentry.init do |config|
  config.traces_sample_rate = 0.2
  config.profiles_sample_rate = 0.5
  config.breadcrumbs_logger = %i[sentry_logger http_logger active_support_logger]
  config.excluded_exceptions += [
    'Rack::Utils::InvalidParameterError' # Rack was unable to decode a parameter
  ]
end

ActiveSupport::Deprecation.behavior = %i[stderr notify]
ActiveSupport::Notifications.subscribe('deprecation.rails') do |_, _, _, _, payload|
  Sentry.capture_message(payload[:message], {
    level: 'warning',
    backtrace: payload[:callstack].map(&:to_s)
  })
end
