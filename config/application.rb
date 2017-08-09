require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Kitsu
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified
    # here.  Application configuration should go into files in
    # config/initializers -- all .rb files in that directory are automatically
    # loaded.

    # Enable assets (used by rails_admin, emails)
    config.assets.enabled = true
    config.assets.prefix = '/api/assets'
    config.assets.digest = true

    # UTC all the way
    config.time_zone = 'UTC'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Include all concern directories in app/*/concerns
    concern_dirs = Dir['app/*/concerns'].map { |d| File.expand_path(d) }
    config.eager_load_paths += concern_dirs
    # Eager-load list_import files
    import_dirs = Dir['lib/list_import'].map { |d| File.expand_path(d) }
    config.eager_load_paths += import_dirs
    # Include all services files
    config.eager_load_paths += Dir["#{config.root}/app/services/**/"]
    # Rip out any non-unique entries
    config.eager_load_paths.uniq!

    # Allow autoloading any lib files
    # TODO: fix or kill rails_admin, bring this back
    # config.autoload_paths << "#{Rails.root}/lib"

    # Set log level to LOG_LEVEL environment variable
    config.log_level = ENV['LOG_LEVEL'] || :info

    # Normally we wanna be API-only, but we mount some admin panels in, so... :(
    config.api_only = false

    # Enable CORS
    config.middleware.insert_before 0, 'Rack::Cors' do
      allow do
        origins '*'
        resource '*', headers: :any,
                      methods: :any,
                      credentials: false,
                      max_age: 1.hour
      end
    end

    # Fancy new URLs for images
    config.paperclip_defaults = {
      url: '/system/:class/:attachment/:id/:style.:content_type_extension'
    }

    # Email Server
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.smtp_settings = {
      address: ENV['SMTP_ADDRESS'],
      port: ENV['SMTP_PORT']&.to_i,
      user_name: ENV['SMTP_USERNAME'],
      password: ENV['SMTP_PASSWORD'],
      authentication: ENV['SMTP_AUTHENTICATION']&.to_sym
    }.compact

    # Redis caching
    config.cache_store = :redis_store, ENV['REDIS_URL'], { expires_in: 1.day }

    # Set ActiveJob adapter
    config.active_job.queue_adapter = :sidekiq

    # Configure Scaffold Generators
    config.generators do |g|
      g.authorization :policy
      g.serialization :jsonapi_resource
      g.resource_controller :resource_controller
    end
  end
end
