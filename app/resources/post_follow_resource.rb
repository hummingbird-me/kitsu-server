class PostFollowResource < BaseResource
  attributes :created_at, :updated_at
  has_one :post
  has_one :user
  filter :post_id
  filter :user_id
end
