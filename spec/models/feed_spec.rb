require 'rails_helper'

RSpec.describe Feed, type: :model do
  subject { Feed.new('user_aggr', '1') }

  it { should delegate_method(:readonly_token).to(:stream_feed) }

  describe '#activities' do
    it 'should return an ActivityList for the feed' do
      expect(subject.activities).to be_an(Feed::ActivityList)
      expect(subject.activities.feed).to eq(subject)
    end
  end

  describe '#stream_id' do
    it 'should return the group and id separated by a colon' do
      expect(subject.stream_id).to eq('user_aggr:1')
    end
  end

  describe '#==' do
    it 'should return true if they refer to the same feed' do
      expect(subject == subject.dup).to be true
    end

    it 'should return false if they refer to a different feed' do
      other = Feed.new('global', 'global')
      expect(subject == other).to be false
    end
  end

  describe '.user_aggr' do
    subject { Feed.user_aggr(1) }
    it 'should return a user aggregated feed' do
      expect(subject.group).to eq('user_aggr')
    end
    it 'should have the id we gave' do
      expect(subject.id).to eq('1')
    end
  end

  describe '.media_aggr' do
    subject { Feed.media_aggr('anime', 123) }
    it 'should return a media aggregated feed' do
      expect(subject.group).to eq('media_aggr')
    end
    it 'should have the type and id we gave, separated by a hyphen' do
      expect(subject.id).to eq('anime-123')
    end
  end

  describe '#follow' do
    it 'should call on stream_feed.follow' do
      target_feed = Feed.new('media', '7')
      expect(subject.stream_feed).to receive(:follow).with('media', '7')
      subject.follow(target_feed)
    end
  end

  describe '#unfollow' do
    it 'should call on stream_feed.unfollow' do
      target_feed = Feed.new('media', '7')
      expect(subject.stream_feed).to receive(:unfollow).with('media', '7')
      subject.unfollow(target_feed)
    end
  end

  describe 'available feeds' do
    subject { described_class }

    it { respond_to :user_posts }
    it { respond_to :user_media }
    it { respond_to :user_aggr }
    it { respond_to :user_posts_aggr }
    it { respond_to :user_media_aggr }
    it { respond_to :media_posts }
    it { respond_to :media_media }
    it { respond_to :media_aggr }
    it { respond_to :media_posts_aggr }
    it { respond_to :media_media_aggr }
    it { respond_to :group }
    it { respond_to :group_aggr }
    it { respond_to :post }
    it { respond_to :reports_aggr }
    it { respond_to :timeline }
    it { respond_to :timeline_posts }
    it { respond_to :timeline_media }
    it { respond_to :notifications }
  end

  describe '.global' do
    it 'returns the global feed' do
      expect(described_class.global).to eq(Feed.new('global', 'global'))
    end
  end

  describe '.global_posts' do
    it 'returns the global posts feed' do
      expect(described_class.global_posts)
        .to eq(Feed.new('global_posts', 'global'))
    end
  end

  describe '.global_media' do
    it 'returns the global media feed' do
      expect(described_class.global_media)
        .to eq(Feed.new('global_media', 'global'))
    end
  end
end
