class Types::Volume < Types::BaseObject
  description 'Multiple Chapters of a Manga'

  field :id, ID, null: false

  field :titles, Types::TitlesList,
    null: true,
    description: 'the Titles for this unit in various locales'

  def titles
    {
      localized: object.titles,
      canonical: object.canonical_title
    }
  end

  field :number, Integer,
    null: false,
    description: 'The sequence number of this unit'

  field :thumbnail, Types::Image,
    null: true,
    description: 'A thumbnail image for the unit'

  field :chapters_count, Integer,
    null: false,
    description: 'Total chaters per Volume'

  field :isbn, String,
    null: false,
    description: 'Unique Identification for this Volume'

  field :released_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'The time when the Volume was released',
    method: :published_on
end
