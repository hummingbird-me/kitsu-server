class CommentResource < BaseResource
  attributes :content, :content_formatted, :blocked, :deleted_at, :created_at,
    :likes_count

  has_one :user
  has_one :post
  has_one :parent
  has_many :likes
  has_many :replies

  filters :post_id, :parent_id
end
