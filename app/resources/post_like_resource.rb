class PostLikeResource < BaseResource
  has_one :post
  has_one :user
end
