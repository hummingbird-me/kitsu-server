if Rails.env.production? || Rails.env.staging?
  require 'opentelemetry/sdk'
  require 'opentelemetry/exporter/otlp'

  otlp_logger = Logger.new($stdout)
  otlp_logger.level = :debug

  OpenTelemetry::SDK.configure do |c|
    c.logger = otlp_logger
    c.service_name = 'kitsu-api-web'
    c.use 'OpenTelemetry::Instrumentation::Rack'
    c.use 'OpenTelemetry::Instrumentation::ActionPack'
    c.use 'OpenTelemetry::Instrumentation::ActiveRecord'
    c.use 'OpenTelemetry::Instrumentation::Rails'
    c.use 'OpenTelemetry::Instrumentation::GraphQL'
  end
end
