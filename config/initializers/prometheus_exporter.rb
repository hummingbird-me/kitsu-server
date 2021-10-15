require 'prometheus_exporter/client'
require 'prometheus_exporter/middleware'

Rails.application.middleware.unshift PrometheusExporter::Middleware

if Rails.env.development? || Rails.env.test?
  require 'prometheus_exporter/server'

  server = PrometheusExporter::Server::WebServer.new bind: 'localhost', port: 9394
  server.start
  PrometheusExporter::Client.default = PrometheusExporter::LocalClient.new(
    collector: server.collector
  )
end
