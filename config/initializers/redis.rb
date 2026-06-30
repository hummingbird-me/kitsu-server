$redis = ConnectionPool.new(size: ENV['RAILS_MAX_THREADS'] || 5) do
  Redis.new(url: ENV.fetch('PERSISTENT_REDIS_URL') { ENV.fetch('REDIS_URL', nil) })
end
