class Types::Person < Types::BaseObject
  description 'A Voice Actor, Director, Animator, or other person who works in the creation and\
    localization of media'

  # Identifiers
  field :id, ID, null: false

  field :names, Types::TitlesList,
    null: false,
    description: 'The name of this person in various languages'

  def names
    {
      localized: object.names,
      alternatives: object.other_names,
      canonical: object.canonical_name
    }
  end

  field :birthday, Types::Date,
    null: true,
    description: 'The day when this person was born'

  field :biography, Types::Person,
    null: true,
    description: 'A short biography of the person'

  def biography
    # TODO: actually store localized bio data
    [{ locale: 'en', text: object.description }] if object.description
  end

  field :image, Types::Image,
    null: true,
    description: 'An image of the person'

  field :voices, Types::CharacterVoice,
    null: true,
    description: 'The voice-acting roles this person has had'
end
