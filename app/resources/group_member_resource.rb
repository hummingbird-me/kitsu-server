class GroupMemberResource < BaseResource
  include SortableByFollowing

  attributes :rank, :created_at

  filter :rank, apply: ->(records, values, _options) {
    ranks = GroupMember.ranks.values_at(*values).compact
    ranks = values if ranks.empty?
    records.where(rank: ranks)
  }

  filters :group, :user

  has_one :group
  has_one :user
  has_many :permissions
  has_many :notes
end
