class GroupInviteResource < BaseResource
  has_one :user
  has_one :group
  has_one :sender

  filter :sender
  filter :user
end
