require 'rails_helper'

RSpec.describe Feed::SiteAnnouncementsFeed, type: :model do
  describe '#setup!' do
    it 'should make the feed follow the global' do
      feed = described_class.new('5554')
      expect(feed).to receive(:follow).with(SiteAnnouncementsGlobal.global).once
      feed.setup!
    end
  end
end
