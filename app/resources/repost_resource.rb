class RepostResource < BaseResource
  has_one :user
  has_one :post
end
