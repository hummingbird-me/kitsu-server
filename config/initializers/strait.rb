Strait.configuration = {
  redis: { url: ENV.fetch('REDIS_URL', nil) },
  pool: { size: ENV.fetch('RAILS_MAX_THREADS', 5).to_i }
}
