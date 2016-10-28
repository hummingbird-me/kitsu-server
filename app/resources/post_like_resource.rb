class PostLikeResource < BaseResource
  has_one :post
  has_one :user

  filter :post_id
end
