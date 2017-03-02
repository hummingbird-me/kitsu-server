class GroupInviteResource < BaseResource
  has_one :user
  has_one :group
  has_one :sender

  filters :group, :sender, :user
end
