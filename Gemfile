# frozen_string_literal: true

git_source(:github) { |repo| "https://github.com/#{repo}.git" }
source 'https://rubygems.org'

# Core Stuff
gem 'i18n'
gem 'puma'
gem 'rails', '~> 8.0'

# Database Stuff
gem 'activerecord-import' # Run bulk imports quicker
gem 'attr_encrypted' # encrypt linked_profile tokens
gem 'connection_pool' # Pool our Redises
gem 'fx' # Database functions
gem 'hiredis-client' # Faster redis (redis-rb 5 driver)
gem 'mongo' # MongoDB for Aozora
gem 'pg' # Postgres
gem 'redis', '~> 5.0' # Redis
gem 'scenic' # Database views

# Search
gem 'algoliasearch-rails' # what we tried to switch to (algolia)
gem 'chewy' # the original search (elasticsearch)
gem 'typesensual' # what we're doing now (typesense)

# Auth{entication,orization}
gem 'bcrypt'
gem 'doorkeeper'
gem 'doorkeeper-grants_assertion'
gem 'jwt' # Used for Nolt SSO
gem 'pundit'
gem 'pundit-resources', github: 'hummingbird-me/pundit-resources'
gem 'rolify'

# Attachments
gem 'apollo_upload_server'
gem 'aws-sdk-s3', '~> 1'
gem 'blurhash'
gem 'image_optim', require: false
gem 'image_optim_pack', require: false
gem 'image_processing'
gem 'marcel'
gem 'mini_magick'
gem 'ruby-vips', '~> 2.0'
gem 'shrine'
gem 'shrine-blurhash'

# Background tasks
gem 'sidekiq', '~> 8'
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
gem 'apollo-federation'
gem 'graphql'
gem 'graphql-batch'
gem 'graphql-fancy_loader', path: 'vendor/gems/graphql-fancy_loader'
gem 'jsonapi-resources'

# Miscellaneous Utilities
gem 'active_flag' # Bitfields!
gem 'addressable' # Fancy address logic
gem 'ancestry' # Ancestry for categories
gem 'aws-sdk-sagemakerruntime' # AWS SageMaker
gem 'bootsnap' # Faster boots
gem 'counter_culture' # Fancier counter caches
gem 'after_commit_action' # counter_culture execute_after_commit support
gem 'faraday'
gem 'fastimage' # Quickly get image sizes
gem 'friendly_id' # slug-urls-are-cool
gem 'google-apis-androidpublisher_v3' # Google Play subscription verification
gem 'google-protobuf', force_ruby_platform: RUBY_PLATFORM.include?('linux-musl') # Google Protobuf
gem 'selma', force_ruby_platform: RUBY_PLATFORM.include?('linux-musl') # html-pipeline sanitizer
gem 'graphql-client' # make graphql calls
gem 'http' # Pewpew HTTP calls easier
gem 'ice_cube' # Episode release schedules
gem 'iso-639' # Language codes
gem 'iso_country_codes' # Country codes
gem 'lograge' # Better logging
gem 'mechanize' # Automating interaction with websites
gem 'nokogiri' # Parse MAL XML shit
gem 'oauth2' # Authenticate to Nyckel API
gem 'one_signal' # Send push notifications
gem 'paranoia' # Faux deletion
gem 'postmark-rails' # Send via Postmark
gem 'preferred_locale' # Process Accept-Language headers
gem 'rack-timeout' # Rack timeout
gem 'ranked-model' # Sortables!
gem 'retriable' # Retry when errors happen
gem 'roadie-rails' # Inline CSS for emails
gem 'ruby-progressbar' # Fancy progress bars for Rake tasks
gem 'sass-rails' # Process SCSS for emails
gem 'sitemap_generator' # Generate Sitemaps
gem 'strait', path: 'vendor/gems/strait' # Rate limiting anything!
# Vendored fork of stream_rails with kitsu's subreference-enrichment feature, updated to
# depend on stream-ruby 4.x (the GetStream git fork ref was unfetchable via shallow clone).
gem 'stream_rails', path: 'vendor/gems/stream_rails' # Feed Enrichment
gem 'stream-ruby', '~> 4.1' # Feeds

# Cash Money
gem 'stripe'

# Rack Middleware
gem 'rack-attack'
gem 'rack-cors'

# Standard library gems that became bundled gems in Ruby 3.4+ and must be declared
# explicitly now that they're no longer default gems (used directly across the app).
gem 'csv'
gem 'ostruct'

# Optimizations
gem 'fast_blank' # Faster String#blank?
gem 'oj' # Blazing-fast JSON parsing
gem 'oj_mimic_json' # Hook it in place of JSON gem
gem 'parallel' # Process shit in parallel

# Monitoring
gem 'graphql-metrics'
gem 'health_bit' # Allow Kubernetes to check the health
gem 'marginalia' # Scribble in the margins of our queries
gem 'prometheus_exporter' # Shit out metrics over Prometheus
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'sentry-sidekiq'
gem 'stackprof'

# Admin Panel
gem 'pghero'
gem 'pg_query' # pghero indexes
gem 'rails_admin'
gem 'sassc-rails' # used by rails admin
gem 'sinatra' # used by sidekiq/web

group :development, :test do
  gem 'dead_end' # Better error messages for missing `end`
  gem 'dotenv-rails' # Load default ENV
  gem 'pry-rails' # Better Console
  gem 'spring' # Faster CLI

  # Rubocop stuff
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false

  # Development+Testing
  gem 'database_cleaner' # Clean the database fully before doing anything
  gem 'factory_bot_rails' # Factories > Fixtures
  gem 'rspec-rails' # Specs > Tests

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
  gem 'pundit-matchers' # Test pundit policies
  gem 'rspec-sidekiq' # Test Sidekiq jobs
  gem 'shoulda-matchers' # it { should(:have_shoulda) }
  gem 'stripe-ruby-mock', github: 'stripe-ruby-mock/stripe-ruby-mock',
    require: 'stripe_mock' # Mock Stripe API
  gem 'temping' # Temp models+tables
  gem 'timecop' # stop [hammer-]time
  gem 'webmock' # Web faking

  # Coverage
  gem 'simplecov' # Local coverage
end

group :ci do
  gem 'rspec_junit_formatter'
  gem 'simplecov-cobertura'
end

group :production, :staging do
  gem 'puma_worker_killer'
end
