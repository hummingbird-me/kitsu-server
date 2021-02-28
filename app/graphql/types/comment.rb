class Types::Comment < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A comment on a post'

  field :id, ID, null: false

  field :post, Types::Post,
    null: false,
    description: 'The post that this comment is attached to.'

  field :author, Types::Profile,
    null: false,
    description: 'The user who created this comment for the parent post.',
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

  field :likes, Types::Profile.connection_type, null: false do
    description 'Users who liked this comment'
    argument :sort, Loaders::CommentLikesLoader.sort_argument, required: false
  end

  def likes(sort: [{ on: :created_at, direction: :desc }])
    Loaders::CommentLikesLoader.connection_for({
      find_by: :post_id,
      sort: sort
    }, object.id).then do |likes|
      RecordLoader.for(User, token: context[:token]).load_many(likes.map(&:user_id))
    end
  end

  field :replies, Types::Comment.connection_type, null: false do
    description 'Replies to this comment'
    argument :sort, Loaders::CommentsLoader.sort_argument, required: false
  end

  def replies(sort: [{ on: :created_at, direction: :asc }])
    Loaders::CommentsLoader.connection_for({
      find_by: :parent_id,
      sort: sort
    }, object.id)
  end
end
