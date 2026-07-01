class BlockResource < BaseResource
  has_one :user
  has_one :blocked, class_name: 'User'

  filter :user
end
