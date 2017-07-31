class UploadResource < BaseResource
  include ScopelessResource
  attribute :content, format: :attachment

  has_one :user
  has_one :owner, polymorhic: true

  filters :id, :user_id, :owner_id, :owner_type
end
