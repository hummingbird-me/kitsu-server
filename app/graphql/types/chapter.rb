class Types::Chapter < Types::BaseObject
  implements Types::Interface::Unit

  description 'A single chapter of a manga'

  field :released_at, GraphQL::Types::ISO8601Date,
    method: :published,
    null: true,
    description: 'When this chapter was released'

  field :volume, Types::Volume,
    null: true,
    description: 'The volume this chapter is in.'

  field :manga, Types::Manga,
    null: false,
    description: 'The manga this chapter is in.'
end
