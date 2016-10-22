class FollowResource < BaseResource
  has_one :follower
  has_one :followed
end
