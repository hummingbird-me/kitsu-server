# frozen_string_literal: true

class Types::Category < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'Information about a specific Category'

  field :id, ID, null: false

  field :title,
    resolver: Resolvers::LocalizedField.from(:title),
    null: false,
    description: 'The name of the category.'

  field :description,
    resolver: Resolvers::LocalizedField,
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

  def parent
    Loaders::RecordLoader.for(Category, token: context[:token]).load(object.parent_id)
  end

  field :root, Types::Category,
    null: true,
    description: 'The top-level ancestor category'

  def root
    Loaders::RecordLoader.for(Category, token: context[:token]).load(object.root_id)
  end

  field :children, Types::Category.connection_type,
    null: true,
    description: 'The child categories.'

  def children
    Loaders::AssociationLoader.for(object.class, :children, policy: :category).scope(object)
  end
end
