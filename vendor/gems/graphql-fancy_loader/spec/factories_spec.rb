require 'spec_helper'

RSpec.describe 'FactoryBot' do
  before(:all) do
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.start
  end
  after(:all) { DatabaseCleaner.clean }
end
