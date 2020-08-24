class Types::Category < Types::BaseObject
  include HasLocalizedField
  implements Types::Interface::WithTimestamps

  description 'Information about a specific Category'

  field :id, ID, null: false

  localized_field :title,
    null: false,
    description: 'The name of the category.'

  def title
    { en: object.title } if object.title
  end

  localized_field :description,
    description: 'A brief summary or description of the catgory.'

  field :slug, String,
    null: false,
    description: 'The URL-friendly identifier of this Category.'

  field :is_nsfw, Boolean,
    null: false,
    description: 'Whether the category is Not-Safe-for-Work.',
    method: :nsfw?

  field :parent, Types::Category,
    null: true,
    description: 'The parent category. Each category can have one parent.'

  field :children, Types::Category.connection_type,
    null: true,
    description: 'The child categories.'

  def children
    AssociationLoader.for(object.class, :children, policy: :category).scope(object)
  end
end
