module Types::MediaUnit
  include Types::BaseInterface
  description 'A media unit in the Kitsu database'

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

  field :synopsis, [Types::LocalizedString],
    null: true,
    description: 'A brief summary or description of the unit'

  def synopsis
    # TODO: actually store localized synopsis data
    [{ locale: 'en', text: object.synopsis }] if object.synopsis
  end

  field :length, Integer,
    null: true,
    description: 'The length of the unit in seconds or pages'

  field :thumbnail, Types::Image,
    null: true,
    description: 'A thumbnail image for the unit'
end
