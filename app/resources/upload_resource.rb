class UploadResource < BaseResource
  include ScopelessResource
  include RankedResource

  attribute :content, format: :attachment
  attribute :order
  ranks :order

  has_one :user
  has_one :owner, polymorhic: true

  filters :id, :user_id, :owner_id, :owner_type
end
