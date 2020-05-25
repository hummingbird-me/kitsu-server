class Types::Post < Types::BaseObject
  description 'A post that is visible to your followers and globally in the news-feed.'

  field :id, ID, null: false

  field :profile, Types::Profile,
    null: false,
    description: 'The user who created this post.',
    method: :user

  field :media, Types::Media,
    null: true,
    description: 'The media tagged in this post.'

  field :spoiler, Boolean,
    null: false,
    description: 'If this post spoils the tagged media.'

  field :nsfw, Boolean,
    null: false,
    description: 'If a post is Not-Safe-for-Work.',
    method: :nsfw?

  field :content, String,
    null: false,
    description: 'Unmodified content.'

  field :content_formatted, String,
    null: false,
    description: 'Html formatted content.'

  field :comments, Types::Comment.connection_type,
    null: false,
    description: 'All comments related to this post.'

  field :likes, Types::Profile.connection_type,
    null: false,
    description: 'Users that have liked this post.'

  field :follows, Types::Profile.connection_type,
    null: false,
    description: 'Users that are watching this post'

  # field :uploads, Types::Image.connection_type,
  #   null: false,
  #   description: ''

  def comments
    AssociationLoader.for(object.class, :comments).load(object)
  end

  def likes
    AssociationLoader.for(object.class, :post_likes).load(object).then do |likes|
      likes.map(&:user)
    end
  end

  def follows
    AssociationLoader.for(object.class, :post_follows).load(object).then do |follows|
      follows.map(&:user)
    end
  end
end
