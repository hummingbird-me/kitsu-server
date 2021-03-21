module SiteAnnouncements
  class MarkRead < Action
    parameter :user, load: User, required: true
    parameter :announcement_ids, required: true

    def call
      announcements = SiteAnnouncement.find(announcement_ids)

      views = SiteAnnouncementView.ensure!(user, announcements)
      views.each(&:read!)

      { site_announcement_views: views }
    end
  end
end
