class GroupMemberResource < BaseResource
  attributes :rank, :created_at

  filters :rank, :group, :user

  has_one :group
  has_one :user
  has_many :permissions
end
