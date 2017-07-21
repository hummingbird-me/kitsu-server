class FollowResource < BaseResource
  attribute :hidden

  has_one :follower
  has_one :followed

  filter :follower
  filter :followed
end
