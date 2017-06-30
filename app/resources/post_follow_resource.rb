class PostFollowResource < BaseResource
  has_one :post
  has_one :user

  filter :post_id
  filter :user_id
end
