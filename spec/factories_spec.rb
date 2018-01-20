require 'rails_helper'

RSpec.describe 'FactoryBot' do
  before(:all) { DatabaseCleaner.start }
  after(:all) { DatabaseCleaner.clean }

  FactoryBot.factories.each do |factory|
    it "#{factory.name} should pass lint" do
      FactoryBot::Linter.new([factory], :factory).lint!
    end
  end
end
