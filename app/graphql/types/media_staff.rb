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

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media'
end
