class Mutations::SiteAnnouncements < Mutations::Namespace
  field :mark_read,
    mutation: Mutations::SiteAnnouncements::MarkRead,
    description: 'Mark some announcements as read'

  field :mark_seen,
    mutation: Mutations::SiteAnnouncements::MarkSeen,
    description: 'Mark some announcements as seen'
end
