require 'sidekiq/middleware/server/chewy'

Sidekiq.default_worker_options = { queue: 'later' }

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::Chewy
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end
