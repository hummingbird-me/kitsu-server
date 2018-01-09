source 'https://rubygems.org'
ruby '2.3.1'

# Core Stuff
gem 'puma'
gem 'rails', '4.2.10'
gem 'rails-api'

# Database Stuff
gem 'activerecord-import' # Run bulk imports quicker
gem 'algoliasearch-rails' # Future Search
gem 'attr_encrypted', '~>3.0.0' # encrypt linked_profile tokens
gem 'chewy' # ElasticSearch (TODO: remove this once we switch to Algolia)
gem 'connection_pool' # Pool our Redises
gem 'hiredis' # Faster redis
gem 'pg' # Postgres
gem 'redis', '> 3.3.0', require: ['redis', 'redis/connection/hiredis'] # Redis
gem 'redis-rails' # Redis on Rails
gem 'where-or' # RAILS-5: Remove this, it just backports AR#where

# Auth{entication,orization}
gem 'bcrypt'
gem 'doorkeeper'
gem 'doorkeeper-grants_assertion', git: 'https://github.com/doorkeeper-gem/doorkeeper-grants_assertion'
gem 'pundit'
gem 'pundit-resources'
gem 'rolify'
gem 'twitter'

# Attachments
gem 'aws-sdk', '< 3.0'
gem 'delayed_paperclip'
gem 'image_optim', require: false
gem 'image_optim_pack', require: false
gem 'paperclip', '~> 5.0'
gem 'paperclip-meta'
gem 'paperclip-optimizer'

# Background tasks
gem 'sidekiq', '~> 5'
gem 'sidekiq-debounce'
gem 'sidekiq-scheduler'

# Text pipeline
gem 'html-pipeline'
gem 'kramdown'
gem 'onebox'
gem 'rinku'
gem 'sanitize'

# Feature Flagging
gem 'flipper'
gem 'flipper-redis'
gem 'flipper-ui'

# Miscellaneous Utilities
gem 'addressable' # Fancy address logic
gem 'counter_culture' # Fancier counter caches
gem 'friendly_id' # slug-urls-are-cool
gem 'jsonapi-resources', '0.9.0'
gem 'lograge' # Non-shitty logging
gem 'mechanize' # Automating interaction with websites
gem 'nokogiri', '~> 1.8.1' # Parse MAL XML shit
gem 'one_signal' # Send push notifications
gem 'paranoia', '~> 2.4' # Faux deletion
gem 'rack-timeout', github: 'nuckchorris/rack-timeout'
gem 'ranked-model' # Sortables!
gem 'rbtrace' # Attach to running ruby processes
gem 'ruby-progressbar' # Fancy progress bars for Rake tasks
gem 'sitemap_generator' # Generate Sitemaps
gem 'stream-ruby', '~> 2.5.10' # Feeds
gem 'stream_rails', github: 'GetStream/stream-rails',
                    branch: 'feature/subreference-enrichment' # Feed Enrichment
gem 'typhoeus' # Parallelize scraping tasks

# Rack Middleware
gem 'rack-attack'
gem 'rack-cors'

# Optimizations
gem 'fast_blank' # Faster String#blank?
gem 'oj' # Blazing-fast JSON parsing
gem 'oj_mimic_json' # Hook it in place of JSON gem

gem 'sentry-raven' # Send error data to Sentry

# Admin Panel
gem 'pg_query' # pghero indexes
gem 'pghero'
gem 'rails_admin'
gem 'sinatra' # used by sidekiq/web

group :development, :test do
  gem 'annotate' # Schema annotations inside model-related files
  gem 'dotenv-rails' # Load default ENV
  gem 'pry-rails' # Better Console
  gem 'spring' # Faster CLI

  # Development+Testing
  gem 'database_cleaner' # Clean the database fully before doing anything
  gem 'factory_girl_rails' # Factories > Fixtures
  gem 'rspec-rails' # Specs > Tests

  # Guard notices filesystem changes and *does things*
  gem 'guard'
  gem 'guard-rspec', require: false # Running specs

  # Useful for benchmarking!
  gem 'benchmark-ips'

  # Debugging tests and scripts
  gem 'pry-byebug'
end

group :test do
  gem 'codeclimate-test-reporter' # CodeClimate coverage
  gem 'faker' # Fake data
  gem 'json_expressions' # Test outputted JSON
  gem 'rspec-sidekiq' # Test Sidekiq jobs
  gem 'shoulda-matchers' # it { should(:have_shoulda) }
  gem 'simplecov' # Local coverage
  gem 'test_after_commit' # Rails 4 doesn't run commit callbacks on transactions
  gem 'timecop' # stop [hammer-]time
  gem 'webmock' # Web faking

  # Libraries used to test our API itself
  gem 'oauth2'
end

group :production, :staging do
  gem 'librato-rails' # Metrics
  gem 'puma_worker_killer'
  gem 'rails_12factor' # Log to stdout, serve assets
  gem 'skylight' # Performance Monitoring
end
