class Types::Chapter < Types::BaseObject
  description 'A chapter of a Manga'

  field :id, ID, null: false

  field :titles, Types::TitlesList,
    null: false,
    description: 'the Titles for this chapter in various locales'

  def titles
    {
      localized: object.titles,
      canonical: object.canonical_title
    }
  end

  field :volume_number, Integer,
    null: false,
    description: 'The volume this chapter is related to'

  field :number, Integer,
    null: false,
    description: 'The sequence number of this chapter'

  field :synopsis, [Types::LocalizedString],
    null: true,
    description: 'A brief summary or description of the chapter'

  def synopsis
    # TODO: actually store localized synopsis data
    [{ locale: 'en', text: object.synopsis }] if object.synopsis
  end

  field :length, Integer,
    null: true,
    description: 'The length of the chapter by pages'

  field :published, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'The time when the chapter was released'

  field :thumbnail, Types::Image,
    null: true,
    description: 'A thumbnail image for the chapter'
end
