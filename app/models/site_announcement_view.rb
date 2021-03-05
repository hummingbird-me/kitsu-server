class SiteAnnouncementView < ApplicationRecord
  belongs_to :site_announcement
  belongs_to :user

  validate :user, uniqueness: { scope: :site_announcement_id }

  # Whether this SiteAnnouncement has been displayed to the user at some point
  def seen?
    seen_at.present?
  end

  # Whether this SiteAnnouncement has been dismissed by the user
  def read?
    read_at.present?
  end
end
