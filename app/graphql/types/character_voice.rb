class Types::CharacterVoice < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'Information about a VA (Person) voicing a Character in a Media'

  field :id, ID, null: false

  field :media_character, Types::MediaCharacter,
    null: false,
    description: 'The MediaCharacter node'

  field :person, Types::Person,
    null: false,
    description: 'The person who voice acted this role'

  def person
    Loaders::RecordLoader.for(Person).load(object.person_id)
  end

  field :locale, String,
    null: false,
    description: 'The BCP47 locale tag for the voice acting role'

  field :licensor, Types::Producer,
    null: true,
    description: 'The company who hired this voice actor to play this role'

  def licensor
    Loaders::RecordLoader.for(Producer).load(object.licensor_id)
  end
end
