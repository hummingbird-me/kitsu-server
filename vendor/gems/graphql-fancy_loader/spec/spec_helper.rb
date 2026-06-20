# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter 'lib/strait/version'
  track_files 'lib/**/*.rb'
end

require File.expand_path('../spec/dummy/config/environment.rb', __dir__)
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '../../../spec/dummy'

require 'rspec/rails'
# Require supporting ruby files in spec/support
# Do not end their names in _spec, or it'll bug out
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# require 'graphql-fancy-loader'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ActiveRecord::Migration.maintain_test_schema!

# set up db
# be sure to update the schema if required by doing
# - cd spec/dummy
# - rake db:schema:load
ActiveRecord::Schema.verbose = false
load './spec/dummy/db/schema.rb' # db agnostic
