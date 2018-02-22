require 'rails_helper'

RSpec.describe Feed, type: :model do
  subject do
    Class.new(Feed) do
      def default_target
        ['test', id]
      end
      alias_method :write_target, :default_target
      alias_method :read_target, :default_target
    end
  end
  let(:feed) { subject.new('1') }
  let(:read_feed) { double }
  let(:write_target) { ['test', 17] }

  describe '#activities' do
    it 'should return an ActivityList for the feed' do
      expect(feed.activities).to be_an(Feed::ActivityList)
      expect(feed.activities.feed).to eq(feed)
    end
  end

  describe '#follow' do
    context 'with a Feed target' do
      it 'should add a follow from self.read_feed to target.write_feed' do
        target_feed = MediaFeed.new('Anime', '7')
        allow(feed).to receive(:read_feed).and_return(read_feed)
        allow(target_feed).to receive(:write_target).and_return(write_target)

        expect(read_feed).to receive(:follow).with(*write_target, activity_copy_limit: 17)
        feed.follow(target_feed, scrollback: 17)
      end
    end

    context 'with a feed tuple target' do
      it 'should add a follow from self.read_feed to the target' do
        allow(feed).to receive(:read_feed).and_return(read_feed)
        expect(read_feed).to receive(:follow).with('foo', 1, activity_copy_limit: 13)
        feed.follow(['foo', 1], scrollback: 13)
      end
    end
  end

  describe '#follow_many' do
    it 'should add multiple follows from self.read_feed to targets' do
      target_feeds = [['foo', 1], ['bar', 1]]
      allow(feed).to receive(:read_feed).and_return(read_feed)

      expect(read_feed).to receive(:follow).twice
      feed.follow_many(target_feeds)
    end
  end

  describe '#unfollow' do
    it 'should remove a follow from self.read_feed to target.write_feed' do
      target_feed = MediaFeed.new('Anime', '7')
      allow(feed).to receive(:read_feed).and_return(read_feed)
      allow(target_feed).to receive(:write_target).and_return(write_target)

      expect(read_feed).to receive(:unfollow).with(*write_target, keep_history: false)
      feed.unfollow(target_feed, keep_history: false)
    end
  end

  describe '#unfollow_many' do
    context 'with a Feed target' do
      it 'should remove multiple follows from self.read_feed to targets' do
        target_feeds = [['foo', 1], ['bar', 1]]
        allow(feed).to receive(:read_feed).and_return(read_feed)

        expect(read_feed).to receive(:unfollow).twice
        feed.unfollow_many(target_feeds)
      end
    end

    context 'with a feed tuple target' do
      it 'should remove a follow from self.read_feed to the target' do
        allow(feed).to receive(:read_feed).and_return(read_feed)
        expect(read_feed).to receive(:unfollow).with('foo', 1, keep_history: false)
        feed.unfollow(['foo', 1], keep_history: false)
      end
    end
  end
end
