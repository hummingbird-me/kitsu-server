class UploadResource < BaseResource
  include ScopelessResource
  include RankedResource

  attribute :content, format: :shrine_attachment
  attribute :upload_order
  ranks :upload_order

  def content
    _model.content_attacher
  end

  def content=(value)
    _model.content_data_uri = value
  end

  has_one :user
  has_one :owner, polymorhic: true

  filters :id, :user_id, :owner_id, :owner_type
end
