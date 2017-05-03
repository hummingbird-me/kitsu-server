require 'rails_helper'

RSpec.describe Feed::SiteAnnouncementsFeed, type: :model do
  describe '#setup!' do
    it 'should make the feed follow the global' do
      feed = described_class.new('5554')
      expect(feed).to receive(:follow).with(described_class.global).once
      feed.setup!
    end
  end

  describe '.global' do
    it 'should return the global announcement feed' do
      expect(described_class.global.id).to eq('global')
    end
  end
end
