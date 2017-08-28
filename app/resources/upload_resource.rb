class UploadResource < BaseResource
  include ScopelessResource
  include RankedResource

  attribute :content, format: :attachment
  attribute :upload_order
  ranks :upload_order

  has_one :user
  has_one :owner, polymorhic: true

  filters :id, :user_id, :owner_id, :owner_type
end
