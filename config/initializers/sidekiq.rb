require 'sidekiq/middleware/server/chewy'
require 'sidekiq/middleware/server/librato_metrics'
require 'sidekiq/middleware/server/current_user'
require 'sidekiq/middleware/server/stream_buffer_flusher'
require 'sidekiq/middleware/client/current_user'

Sidekiq.default_worker_options = { queue: 'later' }

Sidekiq.configure_server do |config|
  require 'prometheus_exporter/instrumentation'

  config.on :startup do
    PrometheusExporter::Instrumentation::SidekiqQueue.start
    PrometheusExporter::Instrumentation::Process.start(type: 'worker')
    PrometheusExporter::Instrumentation::ActiveRecord.start(
      custom_labels: { type: 'worker' },
      config_labels: %i[database host]
    )
  end

  config.logger.level = ENV['LOG_LEVEL'].to_sym if ENV['LOG_LEVEL']
  config.redis = { url: ENV['REDIS_URL'], network_timeout: 3, pool_timeout: 3 }
  config.server_middleware do |chain|
    chain.add Sidekiq::Debounce
    chain.add PrometheusExporter::Instrumentation::Sidekiq
    chain.add Sidekiq::Middleware::Server::CurrentUser
    chain.add Sidekiq::Middleware::Server::Chewy
    chain.add Sidekiq::Middleware::Server::StreamBufferFlusher
    chain.add Sidekiq::Middleware::Server::LibratoMetrics if defined? Librato
  end
  config.death_handlers << PrometheusExporter::Instrumentation::Sidekiq.death_handler
  config.client_middleware do |chain|
    chain.add Sidekiq::Middleware::Client::CurrentUser
  end

  at_exit do
    PrometheusExporter::Client.default.stop(wait_timeout_seconds: 10)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], network_timeout: 3, pool_timeout: 3 }

  config.client_middleware do |chain|
    chain.add Sidekiq::Middleware::Client::CurrentUser
  end
end
