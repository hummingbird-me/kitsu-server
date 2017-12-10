web: bundle exec puma -C config/puma.rb
worker: LIBRATO_AUTORUN=1 bundle exec sidekiq
release: bundle exec rake db:migrate
