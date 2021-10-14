if Rails.env.production? || Rails.env.staging?
  require 'opentelemetry/sdk'
  require 'opentelemetry/exporter/otlp'

  otlp_logger = Logger.new($stdout)
  otlp_logger.level = :debug

  OpenTelemetry::SDK.configure do |c|
    c.logger = otlp_logger
    c.service_name = 'kitsu-api-web'
    c.use_all
  end
end
