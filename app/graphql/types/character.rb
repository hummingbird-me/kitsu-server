# frozen_string_literal: true

class Types::Character < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'Information about a Character in the Kitsu database'

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

  field :description,
    resolver: Resolvers::LocalizedField,
    description: 'A brief summary or description of the character.'

  field :primary_media, Types::Interface::Media,
    null: true,
    description: 'The original media this character showed up in'

  image_field :image,
    description: 'An image of the character'

  field :media, Types::MediaCharacter.connection_type,
    null: true,
    description: 'Media this character appears in.'

  def media
    Loaders::AssociationLoader.for(object.class, :media_characters).scope(object)
  end
end
