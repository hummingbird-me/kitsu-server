class Types::Volume < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A manga volume which can contain multiple chapters.'

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
    description: 'The volume number.'

  field :published, GraphQL::Types::ISO8601Date,
    null: true,
    description: 'The date when this chapter was released.',
    method: :published_on

  field :manga, Types::Manga,
    null: false,
    description: 'The manga this volume is in.'

  field :isbn, [String],
    null: false,
    description: 'The isbn number of this volume.'

  field :chapters, Types::Chapter.connection_type,
    null: true,
    description: 'The chapters in this volume.'

  def chapters
    Loaders::AssociationLoader.for(object.class, :chapters).scope(object)
  end
end
