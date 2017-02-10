source 'https://rubygems.org'
ruby '2.3.1'

# Core Stuff
gem 'puma'
gem 'rails', '4.2.1'
gem 'rails-api'

# Database Stuff
gem 'attr_encrypted', '~>3.0.0' # encrypt linked_profile tokens
gem 'chewy' # ElasticSearch
gem 'connection_pool' # Pool our Redises
gem 'hiredis' # Faster redis
gem 'pg' # Postgres
gem 'redis', require: ['redis', 'redis/connection/hiredis'] # Redis
gem 'redis-rails' # Redis on Rails

# Auth{entication,orization}
gem 'bcrypt'
gem 'doorkeeper'
gem 'doorkeeper-grants_assertion', git: 'https://github.com/doorkeeper-gem/doorkeeper-grants_assertion'
gem 'pundit'
gem 'pundit-resources'
gem 'rolify'
gem 'twitter'

# Attachments
gem 'aws-sdk'
gem 'delayed_paperclip'
gem 'image_optim', require: false
gem 'image_optim_pack', require: false
gem 'paperclip', '~> 5.0'
gem 'paperclip-optimizer'

# Background tasks
gem 'sidekiq', '~> 3.4.2'
gem 'sidetiq'

# Text pipeline
gem 'html-pipeline'
gem 'kramdown'
gem 'onebox'
gem 'rinku'
gem 'sanitize'
gem 'twemoji', github: 'vevix/twemoji'

# Miscellaneous Utilities
gem 'acts_as_list' # Sortables!
# JSON-API resources
gem 'counter_culture' # Fancier counter caches
gem 'friendly_id' # slug-urls-are-cool
gem 'hashie' # Souped-up Hashes
gem 'jsonapi-resources', github: 'cerebris/jsonapi-resources', branch: 'beta'
gem 'nokogiri' # Parse MAL XML shit
gem 'paranoia', '~> 2.0' # Faux deletion
gem 'ruby-progressbar' # Fancy progress bars for Rake tasks
gem 'sitemap_generator' # Generate Sitemaps
gem 'stream-ruby', '~> 2.5.1'
gem 'stream_rails' # Feeds
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
gem 'rails_admin' #admin panel
gem 'paper_trail' #admin history

group :development, :test do
  gem 'annotate' # Schema annotations inside model-related files
  gem 'dotenv-rails' # Load default ENV
  gem 'foreman' # Start processes
  gem 'pry-rails' # Better Console
  gem 'spring' # Faster CLI

  # Development+Testing
  gem 'database_cleaner' # Clean the database fully before doing anything
  gem 'factory_girl_rails' # Factories > Fixtures
  gem 'rspec-rails' # Specs > Tests

  # Guard notices filesystem changes and *does things*
  gem 'guard'
  gem 'guard-rspec', require: false # Running specs
end

group :test do
  gem 'codeclimate-test-reporter' # CodeClimate coverage
  gem 'faker' # Fake data
  gem 'json_expressions' # Test outputted JSON
  gem 'rspec-sidekiq' # Test Sidekiq jobs
  gem 'shoulda-matchers' # it { should(:have_shoulda) }
  gem 'simplecov' # Local coverage
  gem 'timecop' # stop [hammer-]time
  gem 'webmock' # Web faking

  # Libraries used to test our API itself
  gem 'oauth2'
end

group :production, :staging do
  gem 'rails_12factor' # Log to stdout, serve assets
end
