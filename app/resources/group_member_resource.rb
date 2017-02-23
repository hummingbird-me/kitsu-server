class GroupMemberResource < BaseResource
  attributes :role, :created_at

  filters :role, :group, :user

  has_one :group
  has_one :user
  has_many :permissions
end
