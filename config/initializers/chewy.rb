# frozen_string_literal: true

Chewy.settings = {
  sidekiq: {
    queue: 'later'
  },
  transport_options: {
    request: {
      open_timeout: 15,
      timeout: 30
    }
  }
}

if ENV['CHEWY_STRATEGY']
  Chewy.strategy(ENV['CHEWY_STRATEGY'].to_sym)
  Chewy.request_strategy = ENV['CHEWY_STRATEGY'].to_sym
end
