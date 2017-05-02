class SiteAnnouncement < ApplicationRecord
  include WithActivity

  belongs_to :user, required: true

  validates :text, presence: true

  def stream_activity
    Feed::SiteAnnouncementsFeed.global.activities.new
  end
end
