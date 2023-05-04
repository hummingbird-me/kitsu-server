Chewy.settings = {
  sidekiq: {
    queue: 'later'
  }
}

if ENV['CHEWY_STRATEGY']
  Chewy.strategy(ENV['CHEWY_STRATEGY'].to_sym)
  Chewy.request_strategy = ENV['CHEWY_STRATEGY'].to_sym
end
