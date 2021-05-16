unless Rails.env.production?
  require 'prometheus_exporter/server'
  server = PrometheusExporter::Server::WebServer.new bind: 'localhost'
  server.start

  # wire up a default local client
  PrometheusExporter::Client.default = PrometheusExporter::LocalClient.new(
    collector: server.collector
  )
end

unless Rails.env.test?
  require 'prometheus_exporter/middleware'

  # This reports stats per request like HTTP status and timings
  Rails.application.middleware.unshift PrometheusExporter::Middleware
end
