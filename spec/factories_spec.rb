require 'rails_helper'

RSpec.describe 'FactoryGirl' do
  it 'should pass lint' do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint traits: true
    ensure
      DatabaseCleaner.clean
    end
  end
end
