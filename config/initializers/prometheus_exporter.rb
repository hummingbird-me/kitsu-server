# frozen_string_literal: true

require 'prometheus_exporter/client'
require 'prometheus_exporter/middleware'

Rails.application.middleware.unshift PrometheusExporter::Middleware

if Rails.env.development? || Rails.env.test?
  require 'prometheus_exporter/server'

  class NullClient < PrometheusExporter::Client
    def send(*); end
  end

  PrometheusExporter::Client.default = NullClient.new
end

$prometheus = PrometheusExporter::Client.default
