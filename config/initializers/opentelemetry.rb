if Rails.env.production? || Rails.env.staging?
  require 'opentelemetry/sdk'
  require 'opentelemetry/exporter/otlp'
  require 'opentelemetry/instrumentation/all'

  OpenTelemetry::SDK.configure do |c|
    c.service_name = 'kitsu-api-web'
    c.use_all
  end
end
