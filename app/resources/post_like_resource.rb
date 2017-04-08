class PostLikeResource < BaseResource
  include SortableByFollowing

  caching

  attribute :created_at

  has_one :post
  has_one :user

  filter :post_id
  filter :user_id
end
