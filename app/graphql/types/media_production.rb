class Types::MediaProduction < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'The role a company played in the creation or localization of a media'

  # Identifiers
  field :id, ID, null: false

  field :role, Types::Enum::MediaProductionRole,
    null: false,
    description: 'The role this company played'

  field :company, Types::Producer,
    null: false,
    description: 'The production company'

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media'
end
