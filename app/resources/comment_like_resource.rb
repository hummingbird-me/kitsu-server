class CommentLikeResource < BaseResource
  caching

  has_one :comment
  has_one :user

  filter :comment_id
  filter :user_id
end
