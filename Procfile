web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq
release: bundle exec rake db:migrate
sync_worker: bundle exec sidekiq -C config/sidekiq.yml -q sync,10
