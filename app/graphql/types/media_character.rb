class Types::MediaCharacter < Types::BaseObject
  description 'Information about a Character starring in a Media'

  # Identifiers
  field :id, ID, null: false

  field :role, Types::Enum::CharacterRole,
    null: false,
    description: 'The role this character had in the media'

  field :character, Types::Character,
    null: false,
    description: 'The character'

  field :media, Types::Media,
    null: false,
    description: 'The media'

  field :voices, Types::CharacterVoice.connection_type, null: true do
    description 'The voices of this character'
    argument :locale, [String], required: false
  end

  def voices(locale: nil)
    voices = object.voices
    voices = voices.where(locale: locale) if locale
    voices
  end
end
