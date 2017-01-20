Chewy.use_after_commit_callbacks = false if Rails.env.test?
Chewy.strategy(ENV['CHEWY_STRATEGY'].to_sym) if ENV['CHEWY_STRATEGY']
