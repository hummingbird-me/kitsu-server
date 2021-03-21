class SiteAnnouncementView < ApplicationRecord
  belongs_to :announcement, class_name: 'SiteAnnouncement'
  belongs_to :user

  validates :user, uniqueness: { scope: :announcement_id }

  # Whether this SiteAnnouncement has been displayed to the user at some point
  def seen?
    seen_at.present?
  end

  # Mark this announcement as seen
  def seen!
    update(seen_at: Time.now)
  end

  # Whether this SiteAnnouncement has been dismissed by the user
  def read?
    read_at.present?
  end

  # Mark this announcement as read
  def read!
    update(read_at: Time.now)
  end

  # Ensure rows exist for this user for all these announcements
  #
  # @param user [User] the user who we are viewing as
  # @param announcements [SiteAnnouncement[]] the announcements we want to ensure we have views for
  def self.ensure!(user, announcements)
    existing = where(user: user, announcement: announcements).index_by(&:announcement_id)

    to_create = announcements.map do |announcement|
      existing.key?(announcement.id) ? nil : new(user: user, announcement: announcement)
    end

    import!(to_create.compact)

    where(user: user, announcement: announcements)
  end

  # Get a list of anonymous SiteAnnouncementViews for when the user is logged out
  def self.for_anonymous
    SiteAnnouncement.visible.newest_first.map do |announcement|
      new(user: nil, announcement: announcement)
    end
  end

  # Get Relation for the user's views for all announcements they should see
  #
  # @param user [User] the user to get this for
  def self.for_user(user)
    if user.present?
      ensure!(user, SiteAnnouncement.visible)
        .joins(:announcement)
        .merge(SiteAnnouncement.newest_first)
    else
      for_anonymous
    end
  end
end
