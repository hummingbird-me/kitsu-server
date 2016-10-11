require 'rails_helper'

RSpec.describe Feed, type: :model do
  subject { Feed.new('user', '1') }

  describe '#activities' do
    it 'should return an ActivityList for the feed' do
      expect(subject.activities).to be_an(Feed::ActivityList)
      expect(subject.activities.feed).to eq(subject)
    end
  end

  describe '#stream_id' do
    it 'should return the group and id separated by a colon' do
      expect(subject.stream_id).to eq('user:1')
    end
  end

  describe '.user' do
    subject { Feed.user(1) }
    it 'should return a user feed' do
      expect(subject.group).to eq('user')
    end
    it 'should have the id we gave' do
      expect(subject.id).to eq('1')
    end
  end

  describe '.media' do
    subject { Feed.media('anime', 123) }
    it 'should return a media feed' do
      expect(subject.group).to eq('media')
    end
    it 'should have the type and id we gave, separated by a hyphen' do
      expect(subject.id).to eq('anime-123')
    end
  end

  it 'should respond to .timeline and .notifications' do
    expect(described_class).to respond_to(:timeline)
    expect(described_class).to respond_to(:notifications)
  end
end
