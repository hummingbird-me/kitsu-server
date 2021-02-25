class Types::Post < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A post that is visible to your followers and globally in the news-feed.'

  field :id, ID, null: false

  field :author, Types::Profile,
    null: false,
    description: 'The user who created this post.',
    method: :user

  field :media, Types::Interface::Media,
    null: true,
    description: 'The media tagged in this post.'

  field :is_spoiler, Boolean,
    null: false,
    description: 'If this post spoils the tagged media.',
    method: :spoiler?

  field :is_nsfw, Boolean,
    null: false,
    description: 'If a post is Not-Safe-for-Work.',
    method: :nsfw?

  field :content, String,
    null: false,
    description: 'Unmodified content.'

  field :content_formatted, String,
    null: false,
    description: 'Html formatted content.'

  field :locked_by, Types::Profile,
    null: true,
    description: 'The user who locked this post.'

  field :locked_at, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'When this post was locked.'

  field :locked_reason, Types::Enum::LockedReason,
    null: true,
    description: 'The reason why this post was locked.'

  field :embed, Types::Interface::BaseEmbed,
    null: true,
    description: ''

  field :comments, Types::Comment.connection_type,
    null: false,
    description: 'All comments related to this post.'

  def comments
    AssociationLoader.for(object.class, :comments).scope(object)
  end

  field :likes, Types::Profile.connection_type,
    null: false,
    description: 'Users that have liked this post.'

  def likes
    AssociationLoader.for(object.class, :post_likes).scope(object).then do |likes|
      RecordLoader.for(User, token: context[:token]).load_many(likes.pluck(:user_id))
    end
  end

  field :follows, Types::Profile.connection_type,
    null: false,
    description: 'Users that are watching this post'

  def follows
    AssociationLoader.for(object.class, :post_follows).scope(object).then do |follows|
      RecordLoader.for(User, token: context[:token]).load_many(follows.pluck(:user_id))
    end
  end
end
