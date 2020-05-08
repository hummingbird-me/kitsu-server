class Types::Category < Types::BaseObject
  description 'Information about a specific Category'

  field :id, ID, null: false

  field :title, String,
    null: false,
    description: 'The name of the category'

  field :description, String,
    null: true,
    description: 'A description of the category'

  field :slug, String,
    null: false,
    description: 'The URL-friendly identifier of this Category'

  field :anidb_id, Integer,
    null: true,
    description: 'Kitsu category mapping to Anidb category'

  field :total_media_count, Integer,
    null: false,
    description: 'The amount of media that include this category'

  # NOTE: unsure where this method would be defined
  # saw it in Types::Media. Maybe through AR models it is auto defined?
  field :nsfw, Boolean,
    null: false,
    description: 'Whether the category is Not-Safe-for-Work',
    method: :nsfw?

  field :image, Types::Image,
    null: true,
    description: 'An image of the category'

  field :parent, Types::Category,
    null: true,
    description: 'The parent category. Each category can have one parent.'

  field :child_count, Integer,
    null: false,
    description: 'The amount of categories that are children to this category'

  field :children, Types::Category.connection_type,
    null: true,
    description: 'The child categories.'

  def children
    AssociationLoader.for(object.class, :children).load(object)
  end
end
