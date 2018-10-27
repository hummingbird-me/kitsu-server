class Types::Producer < Types::BaseObject
  description 'A company involved in the creation or localization of media'

  # Identifiers
  field :id, ID, null: false

  field :name, String,
    null: false,
    description: 'The name of this production company'
end
