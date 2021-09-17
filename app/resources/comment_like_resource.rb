class CommentLikeResource < BaseResource
  caching

  has_one :comment
  has_one :user

  filter :comment_id
  filter :user_id

  def self.default_sort
    [{ field: 'created_at', direction: :desc }]
  end
end
