class SiteAnnouncementView < ApplicationRecord
  belongs_to :announcement, class_name: 'SiteAnnouncement'
  belongs_to :user

  validates :user, uniqueness: { scope: :announcement_id }

  # Whether this SiteAnnouncement has been displayed to the user at some point
  def seen?
    seen_at.present?
  end

  # Whether this SiteAnnouncement has been dismissed by the user
  def read?
    read_at.present?
  end
end
