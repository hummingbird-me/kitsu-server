class CommentResource < BaseResource
  attributes :content, :content_formatted, :blocked, :deleted_at, :created_at

  has_one :user
  has_one :post
  has_one :parent
  has_many :replies
end
