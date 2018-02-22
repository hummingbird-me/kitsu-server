require 'rails_helper'

RSpec.describe InterestTimelineFeed do
  class TestTimelineFeed < InterestTimelineFeed
    def initialize(user_id)
      super(user_id, 'Test')
    end
  end
  let(:instance) { TestTimelineFeed.new(123) }

  describe '.global' do
    it 'should return the global feed for the subclass' do
      expect(TestTimelineFeed.global.write_target).to eq(%w[interest_global Test])
    end
  end

  describe '.global_for(interest)' do
    it 'should return the global feed for the interest provided' do
      global = described_class.global_for('Test')
      expect(global.write_target).to eq(%w[interest_global Test])
    end
  end
end
