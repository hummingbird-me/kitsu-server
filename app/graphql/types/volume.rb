class Types::Volume < Types::BaseObject
  description 'Multiple Chapters of a Manga'

  field :id, ID, null: false

  field :titles, Types::TitlesList,
    null: true,
    description: 'The titles for this volume in various locales'

  def titles
    {
      localized: object.titles,
      canonical: object.canonical_title
    }
  end

  field :number, Integer,
    null: false,
    description: 'The sequence number of this volume'

  field :thumbnail, Types::Image,
    null: true,
    description: 'A thumbnail image for this volume'

  field :chapters_count, Integer,
    null: false,
    description: 'Total chapters per volume'

  field :isbn, [String],
    null: false,
    description: 'Identification of a specific release of the volume'

  field :released_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'The time when the volume was released',
    method: :published_on
end
