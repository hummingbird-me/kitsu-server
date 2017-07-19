class UploadResource < BaseResource
  include ScopelessResource
  attribute :content

  has_one :user
  has_one :post
  has_one :comment

  filters :id, :user_id, :post_id, :comment_id
end
