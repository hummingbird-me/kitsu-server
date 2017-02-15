class GroupPermissionResource < JSONAPI::Resource
  attribute :permission

  has_one :group_member
end
