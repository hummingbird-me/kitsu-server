class CommentResource < BaseResource
  attributes :content, :content_formatted, :blocked, :deleted_at

  has_one :user
  has_one :post
end
