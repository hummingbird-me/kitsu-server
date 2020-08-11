class Types::Chapter < Types::BaseObject
  include HasLocalizedField

  description 'A single chapter part of a volume.'

  field :id, ID, null: false

  field :titles, Types::TitlesList,
    null: false,
    description: 'The titles for this chapter in various locales'

  def titles
    {
      localized: object.titles,
      canonical: object.canonical_title
    }
  end

  field :number, Integer,
    null: false,
    description: 'The number of pages in this chapter.'

  field :published, GraphQL::Types::ISO8601Date,
    null: true,
    description: 'The date when this chapter was released.'

  # NOTE: once synopsis changes have been merged
  # localized_field :description,
  #   description: 'A brief summary or description of the chapter.'

  field :thumbnail, Types::Image,
    null: true,
    description: 'A thumbnail image for the chapter.'

  field :volume_number, Integer,
    null: true,
    description: 'The volume number this chapter is in.'

  field :volume, Types::Volume,
    null: true,
    description: 'The volume this chapter is in.'

  field :manga, Types::Manga,
    null: false,
    description: 'The manga this chapter is in.'
end
