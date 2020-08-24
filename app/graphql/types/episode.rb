class Types::Episode < Types::BaseObject
  implements Types::Interface::Unit
  implements Types::Interface::WithTimestamps

  description 'An Episode of a Media'

  field :length, Integer,
    null: true,
    description: 'The length of the episode in seconds'

  field :released_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'When this episode aired',
    method: :airdate

  field :anime, Types::Anime,
    null: false,
    description: 'The anime this episode is in'
end
