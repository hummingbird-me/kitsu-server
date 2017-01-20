class RoleResource < BaseResource
  attributes :name, :resource_id, :resource_type

  has_many :user_roles
  has_one :resource, polymorphic: true
end
