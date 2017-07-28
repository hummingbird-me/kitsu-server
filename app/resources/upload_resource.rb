class UploadResource < BaseResource
  include ScopelessResource
  attribute :content, format: :attachment
  attributes :owner_id, :owner_type

  has_one :user

  filters :id, :user_id, :owner_id, :owner_type
end
