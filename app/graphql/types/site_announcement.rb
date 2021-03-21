class Types::SiteAnnouncement < Types::BaseObject
  implements Types::Interface::WithTimestamps
  include HasLocalizedField

  description 'A site-wide announcement for all of Kitsu'

  field :id, ID, null: false

  field :title, String,
    null: false,
    description: 'A short title for the announcement'

  localized_field :description,
    null: true,
    description: 'A brief sentence or two about this announcement'

  field :link, String,
    null: true,
    description: 'A link to learn more about this announcement'

  field :image_url, String,
    null: true,
    description: 'An image to go with this announcement'

  field :author, Types::Profile,
    null: false,
    description: 'The user who made this announcement'

  field :show_at, GraphQL::Types::ISO8601DateTime,
    null: false,
    description: 'The time to start showing this announcement'

  field :hide_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'The time to stop showing this announcement'
end
