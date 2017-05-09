require 'rails_helper'

RSpec.describe SiteAnnouncementsFeed, type: :model do
  describe '#setup!' do
    it 'should make the feed follow the global' do
      feed = described_class.new('5554')
      expect(feed).to receive(:follow).with(SiteAnnouncementsGlobalFeed.new)
        .once
      feed.setup!
    end
  end
end
