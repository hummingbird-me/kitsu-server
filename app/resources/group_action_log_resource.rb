class GroupActionLogResource < BaseResource
  attribute :verb

  has_one :user
  has_one :group
  has_one :target, polymorphic: true

  filter :group
end
