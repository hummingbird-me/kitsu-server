$redis = ConnectionPool.new(size: ENV.fetch('RAILS_MAX_THREADS', 5)) do
  Redis.new
end
