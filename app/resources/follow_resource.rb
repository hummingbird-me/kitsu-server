class FollowResource < BaseResource
  has_one :follower
  has_one :followed

  filter :follower
  filter :followed
end
