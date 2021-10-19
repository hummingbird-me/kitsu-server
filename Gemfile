git_source(:github) { |repo| "https://github.com/#{repo}.git" }
source 'https://rubygems.org'

# Core Stuff
gem 'puma'
gem 'rails', '5.2.4.6'

# Database Stuff
gem 'activerecord-import' , '>= 1.1.0' # Run bulk imports quicker
gem 'algoliasearch-rails' # Future Search
gem 'attr_encrypted', '~>3.1.0' # encrypt linked_profile tokens
gem 'chewy' # ElasticSearch (TODO: remove this once we switch to Algolia)
gem 'connection_pool' # Pool our Redises
gem 'hiredis' # Faster redis
gem 'mongo' # MongoDB for Aozora
gem 'pg' # Postgres
gem 'redis', '> 3.3.0', require: ['redis', 'redis/connection/hiredis'] # Redis

# Auth{entication,orization}
gem 'bcrypt'
gem 'doorkeeper', '~> 5.4.0'
gem 'doorkeeper-grants_assertion', git: 'https://github.com/doorkeeper-gem/doorkeeper-grants_assertion'
gem 'jwt' # Used for Nolt SSO
gem 'pundit'
gem 'pundit-resources', github: 'hummingbird-me/pundit-resources'
gem 'rolify'

# Attachments
gem 'apollo_upload_server', '>= 2.1.0'
gem 'aws-sdk-s3', '~> 1'
# released version of blurhash has too-narrow ffi version
gem 'blurhash', github: 'gargron/blurhash'
gem 'image_optim', require: false
gem 'image_optim_pack', require: false
gem 'image_processing'
gem 'marcel', '>= 0.3.3'
gem 'mini_magick'
gem 'shrine'
gem 'shrine-blurhash', github: 'renchap/shrine-blurhash'

# Background tasks
gem 'sidekiq', '~> 5'
gem 'sidekiq-debounce'
gem 'sidekiq-scheduler'

# Text pipeline
gem 'html-pipeline'
gem 'kramdown'
gem 'kramdown-parser-gfm'
gem 'rinku'
gem 'sanitize'

# Feature Flagging
gem 'flipper'
gem 'flipper-redis'
gem 'flipper-ui'

# API Frameworks
gem 'graphql'
gem 'graphql-batch'
gem 'jsonapi-resources', '0.9.0'

# Miscellaneous Utilities
gem 'active_flag' , '>= 1.5.0' # Bitfields!
gem 'addressable' # Fancy address logic
gem 'ancestry' , '>= 3.2.1' # Ancestry for categories
gem 'bootsnap' # Faster boots
gem 'counter_culture' , '>= 1.11.0' # Fancier counter caches
gem 'faraday'
gem 'faraday_middleware'
gem 'fastimage' # Quickly get image sizes
gem 'friendly_id' , '>= 5.4.2' # slug-urls-are-cool
gem 'google-api-client' # Google APIs
gem 'graphql-client' # make graphql calls
gem 'http' # Pewpew HTTP calls easier
gem 'ice_cube' # Episode release schedules
gem 'mechanize' # Automating interaction with websites
gem 'nokogiri', '~> 1.11.0' # Parse MAL XML shit
gem 'one_signal' # Send push notifications
gem 'paranoia', '~> 2.4', '>= 2.4.3' # Faux deletion
gem 'postmark-rails' , '>= 0.21.0' # Send via Postmark
gem 'ranked-model' , '>= 0.4.7' # Sortables!
gem 'retriable' # Retry when errors happen
gem 'roadie-rails' , '>= 2.2.0' # Inline CSS for emails
gem 'ruby-progressbar' # Fancy progress bars for Rake tasks
gem 'sass-rails' , '>= 6.0.0' # Process SCSS for emails
gem 'sitemap_generator' # Generate Sitemaps
gem 'strait' # Rate limiting anything!
gem 'stream-ruby', '~> 2.10.0' # Feeds
gem 'stream_rails', github: 'GetStream/stream-rails',
                    branch: 'feature/subreference-enrichment' # Feed Enrichment
gem 'typhoeus' # Parallelize scraping tasks

# Cash Money
gem 'stripe'

# Rack Middleware
gem 'rack-attack'
gem 'rack-cors'

# Optimizations
gem 'fast_blank' # Faster String#blank?
gem 'oj' # Blazing-fast JSON parsing
gem 'oj_mimic_json' # Hook it in place of JSON gem
gem 'parallel' # Process shit in parallel

# Monitoring
gem 'health_bit' # Allow Kubernetes to check the health
gem 'marginalia' , '>= 1.11.1' # Scribble in the margins of our queries
gem 'opentelemetry-exporter-otlp'
gem 'opentelemetry-instrumentation-rack'
gem 'opentelemetry-instrumentation-action_pack'
gem 'opentelemetry-instrumentation-active_record'
gem 'opentelemetry-instrumentation-rails'
gem 'opentelemetry-instrumentation-graphql'
gem 'opentelemetry-instrumentation-redis'
gem 'opentelemetry-instrumentation-faraday'
gem 'opentelemetry-instrumentation-mongo'
gem 'opentelemetry-sdk'
gem 'prometheus_exporter' # Shit out metrics over Prometheus
gem 'sentry-raven' # Send error data to Sentry

# Admin Panel
gem 'pg_query' # pghero indexes
gem 'pghero', '>= 2.8.1'
gem 'rails_admin', '>= 2.1.1'
gem 'sinatra' # used by sidekiq/web

group :development, :test do
  gem 'dotenv-rails' , '>= 2.7.6' # Load default ENV
  gem 'pry-rails' # Better Console
  gem 'spring' # Faster CLI

  # Rubocop stuff
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false

  # Development+Testing
  gem 'database_cleaner' , '>= 2.0.1' # Clean the database fully before doing anything
  gem 'factory_bot_rails' , '>= 6.2.0' # Factories > Fixtures
  gem 'rspec-rails' , '>= 5.0.2' # Specs > Tests

  # Guard notices filesystem changes and *does things*
  gem 'guard'
  gem 'guard-rspec', require: false # Running specs

  # Useful for benchmarking!
  gem 'benchmark-ips'
  gem 'derailed_benchmarks'

  # Debugging tests and scripts
  gem 'pry-byebug'
end

group :test do
  gem 'faker' # Fake data
  gem 'json_expressions' # Test outputted JSON
  gem 'rspec-sidekiq' # Test Sidekiq jobs
  gem 'shoulda-matchers' # it { should(:have_shoulda) }
  gem 'stripe-ruby-mock', require: 'stripe_mock' # Mock Stripe API
  gem 'timecop' # stop [hammer-]time
  gem 'webmock' # Web faking

  # Coverage
  gem 'simplecov' # Local coverage

  # Libraries used to test our API itself
  gem 'oauth2'
end

group :production, :staging do
  gem 'librato-rails' , '>= 2.1.0' # Metrics
  gem 'puma_worker_killer'
end
