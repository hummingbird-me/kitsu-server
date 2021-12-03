class SiteAnnouncement < ApplicationRecord
  include WithActivity
  include DescriptionSanitation

  belongs_to :user, required: true

  validates :title, presence: true

  def stream_activity
    SiteAnnouncementsGlobalFeed.new.activities.new
  end
end
