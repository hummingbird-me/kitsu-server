require 'rails_helper'

RSpec.describe 'FactoryBot' do
  before(:all) do
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.start
  end
  after(:all) { DatabaseCleaner.clean }

  FactoryBot.factories.each do |factory|
    it "#{factory.name} should pass lint" do
      FactoryBot::Linter.new([factory]).lint!
    end
  end
end
