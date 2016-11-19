class RoleResource < BaseResource
  attribute :name

  has_many :user_roles
  has_one :resource, polymorphic: true
end
