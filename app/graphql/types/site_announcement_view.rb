class Types::SiteAnnouncementView < Types::BaseObject
  description 'A wrapper marking whether you have seen or read a given SiteAnnouncement'

  field :announcement, Types::SiteAnnouncement,
    null: false,
    description: 'The underlying site announcement'

  field :read, Boolean,
    null: false,
    description: 'Whether the user has acknowledged/dismissed this site announcement',
    method: :read?

  field :seen, Boolean,
    null: false,
    description: 'Whether this site announcement has been displayed to the user',
    method: :seen?
end
