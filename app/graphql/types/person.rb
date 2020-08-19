class Types::Person < Types::BaseObject
  include HasLocalizedField

  description 'A Voice Actor, Director, Animator, or other person who works in the creation and\
    localization of media'

  field :id, ID, null: false

  field :name, String,
    null: false,
    description: 'The primary name of this person.'

  field :slug, String,
    null: false,
    description: 'The URL-friendly identifier of this person.'

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

  localized_field :description,
    description: 'A brief biography or description of the person.'

  field :birthday, Types::Date,
    null: true,
    description: 'The day when this person was born'

  field :image, Types::Image,
    null: true,
    description: 'An image of the person'

  field :voices, Types::CharacterVoice.connection_type,
    null: true,
    description: 'The voice-acting roles this person has had.'

  def voices
    AssociationLoader.for(object.class, :voices, policy: :character_voice).scope(object)
  end
end
