class CommentLikeResource < BaseResource
  has_one :comment
  has_one :user
end
