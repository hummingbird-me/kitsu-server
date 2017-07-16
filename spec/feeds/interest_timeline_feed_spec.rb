require 'rails_helper'

RSpec.describe InterestTimelineFeed do
  class TestTimelineFeed < InterestTimelineFeed
    def initialize(user_id)
      super(user_id, 'Test')
    end
  end
  let(:instance) { TestTimelineFeed.new(123) }

  describe '#default_auto_follows' do
    it 'should include a follow for the interest-global feed' do
      follows = instance.default_auto_follows.map do |f|
        f.transform_values(&:stream_id)
      end
      expect(follows).to include(
        match(
          source: 'interest_timeline:123-Test',
          target: 'interest_global:Test'
        )
      )
    end
  end

  describe '.global' do
    it 'should return the global feed for the subclass' do
      expect(TestTimelineFeed.global.stream_id).to eq('interest_global:Test')
    end
  end

  describe '.global_for(interest)' do
    it 'should return the global feed for the interest provided' do
      global = described_class.global_for('Test')
      expect(global.stream_id).to eq('interest_global:Test')
    end
  end
end
