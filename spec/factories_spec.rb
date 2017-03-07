require 'rails_helper'

RSpec.describe 'FactoryGirl' do
  before(:all) { DatabaseCleaner.start }
  after(:all) { DatabaseCleaner.clean }

  FactoryGirl.factories.each do |factory|
    it "#{factory.name} should pass lint" do
      FactoryGirl::Linter.new([factory], :factory).lint!
    end
  end
end
