$redis = ConnectionPool.new(size: ENV['RAILS_MAX_THREADS'] || 5) do
  Redis.new
end
