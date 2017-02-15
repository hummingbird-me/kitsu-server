class GroupMemberResource < BaseResource
  attributes :role, :created_at

  filter :role, :group, :user

  has_one :group
  has_one :user
  has_many :permissions
end
