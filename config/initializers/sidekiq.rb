require 'sidekiq/middleware/server/chewy'
require 'sidekiq/middleware/server/librato_metrics'

Sidekiq.default_worker_options = { queue: 'later' }

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
  config.server_middleware do |chain|
    chain.add Sidekiq::Debounce
    chain.add Sidekiq::Middleware::Server::Chewy
    chain.add Sidekiq::Middleware::Server::LibratoMetrics if defined? Librato
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end
