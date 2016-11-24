source 'https://rubygems.org'
ruby '2.3.1'

# Core Stuff
gem 'rails', '4.2.1'
gem 'rails-api'
gem 'puma'

# Database Stuff
gem 'pg' # Postgres
gem 'hiredis' # Faster redis
gem 'redis', require: ['redis', 'redis/connection/hiredis'] # Redis
gem 'redis-rails' # Redis on Rails
gem 'connection_pool' # Pool our Redises
gem 'chewy' # ElasticSearch

# Auth{entication,orization}
gem 'bcrypt'
gem 'doorkeeper'
gem 'doorkeeper-grants_assertion', git: 'https://github.com/doorkeeper-gem/doorkeeper-grants_assertion'
gem 'pundit'
gem 'pundit-resources'
gem 'rolify'
gem 'twitter'

# Attachments
gem 'paperclip', '~> 4.1'
gem 'paperclip-optimizer'
gem 'delayed_paperclip'
gem 'image_optim_pack', require: false
gem 'image_optim', require: false
gem 'aws-sdk'

# Background tasks
gem 'sidekiq', '~> 3.4.2'
gem 'sidetiq'

# Text pipeline
gem 'html-pipeline'
gem 'kramdown'
gem 'sanitize'
gem 'onebox'
gem 'twemoji', github: 'vevix/twemoji'
gem 'rinku'

# Miscellaneous Utilities
gem 'friendly_id' # slug-urls-are-cool
gem 'nokogiri' # Parse MAL XML shit
gem 'typhoeus' # Parallelize scraping tasks
gem 'jsonapi-resources', '~> 0.8.0' # JSON-API resources
gem 'jsonapi-utils', '0.5.0.beta3' # Use JR stuff outside their abstraction
gem 'acts_as_list' # Sortables!
gem 'paranoia', '~> 2.0' # Faux deletion
gem 'counter_culture' # Fancier counter caches
gem 'stream_rails' # Feeds
gem 'hashie' # Souped-up Hashes
gem 'ruby-progressbar' # Fancy progress bars for Rake tasks

# Rack Middleware
gem 'rack-cors'

# Optimizations and Profiling
gem 'rack-mini-profiler'
gem 'flamegraph'
gem 'stackprof'
gem 'fast_blank' # Faster String#blank?
gem 'oj' # Blazing-fast JSON parsing

group :development, :test do
  gem 'foreman' # Start processes
  gem 'dotenv-rails' # Load default ENV
  gem 'pry-rails' # Better Console
  gem 'spring' # Faster CLI
  gem 'annotate' # Schema annotations inside model-related files

  # Development+Testing
  gem 'factory_girl_rails' # Factories > Fixtures
  gem 'database_cleaner' # Clean the database fully before doing anything
  gem 'rspec-rails' # Specs > Tests

  # Guard notices filesystem changes and *does things*
  gem 'guard'
  gem 'guard-rspec', require: false # Running specs
end

group :test do
  gem 'shoulda-matchers' # it { should(:have_shoulda) }
  gem 'timecop' # stop [hammer-]time
  gem 'json_expressions' # Test outputted JSON
  gem 'rspec-sidekiq' # Test Sidekiq jobs
  gem 'faker' # Fake data
  gem 'webmock' # Web faking
  gem 'codeclimate-test-reporter' # CodeClimate coverage
  gem 'simplecov' # Local coverage

  # Libraries used to test our API itself
  gem 'oauth2'
end

group :production do
  gem 'rails_12factor' # Log to stdout, serve assets
end
