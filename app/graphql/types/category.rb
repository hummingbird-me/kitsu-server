class Types::Category < Types::BaseObject
  description 'Information about a specific Category'

  field :id, ID, null: false

  field :title, String,
    null: false,
    description: 'The name of the category.'

  field :description, String,
    null: true,
    description: 'A description of the category.'

  field :slug, String,
    null: false,
    description: 'The URL-friendly identifier of this Category.'

  field :nsfw, Boolean,
    null: false,
    description: 'Whether the category is Not-Safe-for-Work.',
    method: :nsfw?

  field :parent, Types::Category,
    null: true,
    description: 'The parent category. Each category can have one parent.'

  field :children, Types::CategoryConnection,
    null: true,
    description: 'The child categories.'
end
