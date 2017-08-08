class CommentResource < BaseResource
  caching

  attributes :content, :content_formatted, :blocked, :deleted_at, :likes_count,
    :replies_count, :edited_at, :embed, :embed_url

  has_one :user
  has_one :post
  has_one :parent
  has_many :likes
  has_many :replies
  has_many :uploads

  filters :post_id, :parent_id
end
