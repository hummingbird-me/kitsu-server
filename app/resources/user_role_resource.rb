class UserRoleResource < BaseResource
  has_one :user
  has_one :role
end
