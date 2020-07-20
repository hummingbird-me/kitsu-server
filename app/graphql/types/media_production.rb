class Types::MediaProduction < Types::BaseObject
  description 'The role a company played in the creation or localization of a media'

  # Identifiers
  field :id, ID, null: false

  field :role, String,
    null: false,
    description: 'The role this company played'

  field :person, Types::Producer,
    null: false,
    description: 'The producer'

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media'
end
