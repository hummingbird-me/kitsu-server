Strait.configuration = {
  redis: { url: ENV['REDIS_URL'] },
  pool: { size: (ENV['RAILS_MAX_THREADS'] || 5).to_i }
}
