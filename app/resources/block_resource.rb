class BlockResource < BaseResource
  has_one :user
  has_one :blocked

  filter :user
end
