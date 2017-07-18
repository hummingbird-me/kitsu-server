require 'rails_helper'

RSpec.describe AnimeTimelineFeed do
  let(:instance) { described_class.new(123) }

  describe '#follow_units_for' do
    it 'should call #follow_many with a bunch of episode follows' do
      skip
      # Mock our follows_for_progress method
      episode_feeds = (0..10).map { |e| EpisodeFeed.new(e) }
      allow(EpisodeFeed).to receive(:follows_for_progress).and_return(episode_feeds)

      expect(instance).to receive(:follow_many).with(episode_feeds)
      instance.follow_units_for(double, 20)
    end
  end

  describe '.global' do
    it 'should return the global feed for Anime' do
      expect(described_class.global.stream_id).to eq('interest_global:Anime')
    end
  end
end
