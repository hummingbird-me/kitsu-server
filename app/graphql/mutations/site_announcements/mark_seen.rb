class Mutations::SiteAnnouncements::MarkSeen < Mutations::Base
  argument :announcement_ids, [ID],
    required: true,
    description: 'Which site announcements to mark as seen'
  field :site_announcement_views, [Types::SiteAnnouncementView], null: true

  def ready?
    raise GraphQL::ExecutionError, ErrorI18n.t(NotLoggedInError) if user.blank?

    true
  end

  def resolve(announcement_ids:)
    SiteAnnouncements::MarkSeen.call(user: user, announcement_ids: announcement_ids)
  end
end
