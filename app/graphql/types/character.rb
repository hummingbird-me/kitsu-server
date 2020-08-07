class Types::Character < Types::BaseObject
  description 'Information about a Character in the Kitsu database'

  # Identifiers
  field :id, ID, null: false

  field :slug, String,
    null: false,
    description: 'The URL-friendly identifier of this character'

  field :names, Types::TitlesList,
    null: true,
    description: 'The name for this character in various locales'

  def names
    {
      localized: object.names,
      alternatives: object.other_names,
      canonical: object.canonical_name
    }
  end

  field :primary_media, Types::Interface::Media,
    null: true,
    description: 'The original media this character showed up in'

  field :image, Types::Image,
    null: true,
    description: 'An image of the character'

  field :media, Types::MediaCharacter.connection_type,
    null: true,
    description: 'Media this character appears in.'

  def media
    AssociationLoader.for(object.class, :media_characters).scope(object)
  end
end
