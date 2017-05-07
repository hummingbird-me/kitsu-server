require 'rails_helper'

RSpec.describe Feed, type: :model do
  subject do
    Class.new(Feed) do
      feed_name 'user'
      feed_type :aggregated
    end
  end
  let(:feed) { subject.new('1') }

  describe '#activities' do
    it 'should return an ActivityList for the feed' do
      expect(feed.activities).to be_an(Feed::ActivityList)
      expect(feed.activities.feed).to eq(feed)
    end
  end

  describe '#stream_id' do
    it 'should return the group and id separated by a colon' do
      expect(feed.stream_id).to eq('user_aggr:1')
    end
  end

  describe '#==' do
    it 'should return true if they refer to the same feed' do
      expect(feed.dup == feed).to be true
    end

    it 'should return false if they refer to a different feed' do
      other = Class.new(Feed).new('test')
      expect(feed == other).to be false
    end
  end

  describe '#follow' do
    it 'should call on StreamFeed.follow_many' do
      target_feed = MediaFeed.new('Anime', '7')
      expect(Feed::StreamFeed).to receive(:follow_many)
      feed.follow(target_feed)
    end
  end

  describe '#unfollow' do
    it 'should call on stream_feed.unfollow' do
      target_feed = MediaFeed.new('Anime', '7')
      stream_feed = feed.send(:stream_feed)
      expect(stream_feed).to receive(:unfollow)
      feed.unfollow(target_feed)
    end
  end
end
