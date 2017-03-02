class GroupPermissionResource < BaseResource
  attribute :permission

  has_one :group_member
end
