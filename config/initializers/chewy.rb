# frozen_string_literal: true

Chewy.settings = {
  sidekiq: {
    queue: 'later'
  },
  transport_options: {
    request: {
      open_timeout: 2,
      timeout: 15
    }
  }
}

if ENV['CHEWY_STRATEGY']
  Chewy.strategy(ENV['CHEWY_STRATEGY'].to_sym)
  Chewy.request_strategy = ENV['CHEWY_STRATEGY'].to_sym
end
