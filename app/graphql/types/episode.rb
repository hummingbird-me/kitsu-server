class Types::Episode < Types::BaseObject
  include HasLocalizedField

  description 'An Episode of a Media'

  field :id, ID, null: false

  field :titles, Types::TitlesList,
    null: false,
    description: 'The titles for this episode in various locales'

  def titles
    {
      localized: object.titles,
      canonical: object.canonical_title
    }
  end

  localized_field :description,
    description: 'A brief summary or description of the episode.'

  field :number, Integer,
    null: false,
    description: 'The sequence number of this episode in the season'

  field :length, Integer,
    null: true,
    description: 'The length of the Episode in seconds'

  field :aired_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'The time when the episode aired',
    method: :airdate

  field :thumbnail, Types::Image,
    null: true,
    description: 'A thumbnail image for the episode'
end
