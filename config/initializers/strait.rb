Strait.configuration = {
  redis: { url: ENV.fetch('PERSISTENT_REDIS_URL') { ENV.fetch('REDIS_URL', nil) } },
  pool: { size: (ENV['RAILS_MAX_THREADS'] || 5).to_i }
}
