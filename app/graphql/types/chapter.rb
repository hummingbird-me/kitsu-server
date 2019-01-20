class Types::Chapter < Types::BaseObject
  implements Types::MediaUnit
  description 'A chapter of a Manga'

  field :id, ID, null: false

  field :volume_number, Integer,
    null: false,
    description: 'The volume this chapter is related to'

  field :released_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'The time when the chapter was released',
    method: :published
end
