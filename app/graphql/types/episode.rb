class Types::Episode < Types::BaseObject
  implements Types::MediaUnitInterface
  description 'An Episode of a Media'

  field :id, ID, null: false

  field :aired_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'The time when the episode aired',
    method: :airdate
end
