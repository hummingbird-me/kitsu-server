class Types::Comment < Types::BaseObject
  description 'A comment on a post'

  field :id, ID, null: false

  field :post, Types::Post,
    null: false,
    description: 'The post that this comment is attached to.'

  field :profile, Types::Profile,
    null: false,
    description: 'The owner of this post',
    method: :user

  field :content, String,
    null: false,
    description: 'Unmodified content.'

  field :content_formatted, String,
    null: false,
    description: 'Html formatted content.'

  field :parent, Types::Comment,
    null: true,
    description: 'The parent comment if this comment was a reply to another.'

  field :likes, Types::Profile.connection_type,
    null: false,
    description: 'Users who liked this comment.'

  field :replies, Types::Comment.connection_type,
    null: false,
    description: 'All replies to a specific comment.'

  def likes
    AssociationLoader.for(object.class, :likes).load(object).then do |likes|
      likes.map(&:user)
    end
  end

  def replies
    AssociationLoader.for(object.class, :replies).load(object)
  end
end
