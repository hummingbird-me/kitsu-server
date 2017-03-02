class GroupBanResource < BaseResource
  attributes :created_at

  has_one :group
  has_one :user
  has_one :moderator
end
