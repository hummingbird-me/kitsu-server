require 'rails_helper'

RSpec.describe SiteAnnouncements::MarkSeen do
  it 'should return a set of announcements which have all been seen' do
    user = create(:user)
    announcements = create_list(:site_announcement, 5)

    result = described_class.call({
      user: user,
      announcement_ids: announcements.map(&:id)
    })

    expect(result.site_announcement_views).to all(be_seen)
  end
end
