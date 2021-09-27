class Types::MediaCharacter < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'Information about a Character starring in a Media'

  # Identifiers
  field :id, ID, null: false

  field :role, Types::Enum::CharacterRole,
    null: false,
    description: 'The role this character had in the media'

  field :character, Types::Character,
    null: false,
    description: 'The character'

  def character
    RecordLoader.for(Character).load(object.character_id)
  end

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media'

  def media
    RecordLoader.for(object.media_type.safe_constantize).load(object.media_id)
  end

  field :voices, Types::CharacterVoice.connection_type, null: true do
    description 'The voices of this character'
    argument :locale, [String], required: false
    argument :sort, Loaders::CharacterVoicesLoader.sort_argument, required: false
  end

  def voices(locale: nil, sort: [{ on: :created_at, direction: :asc }])
    Loaders::CharacterVoicesLoader.connection_for({
      find_by: :media_character_id,
      sort: sort,
      where: { locale: locale }
    }, object.id)
  end
end
