class Types::MediaStaff < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'Information about a person working on an anime'

  # Identifiers
  field :id, ID, null: false

  field :role, String,
    null: false,
    description: 'The role this person had in the creation of this media'

  field :person, Types::Person,
    null: false,
    description: 'The person'

  def person
    Loaders::RecordLoader.for(Person).load(object.person_id)
  end

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media'

  def media
    Loaders::RecordLoader.for(object.media_type.safe_constantize).load(object.media_id)
  end
end
