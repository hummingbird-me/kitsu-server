Chewy.settings = {
  sidekiq: {
    queue: 'later'
  }
}

Chewy.use_after_commit_callbacks = false if Rails.env.test?

if ENV['CHEWY_STRATEGY']
  Chewy.strategy(ENV['CHEWY_STRATEGY'].to_sym)
  Chewy.request_strategy = ENV['CHEWY_STRATEGY'].to_sym
end
