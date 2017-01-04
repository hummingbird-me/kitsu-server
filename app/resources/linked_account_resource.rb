class LinkedAccountResource < BaseResource
  attribute :token
  attributes :external_user_id, :share_to, :share_from,
    :private, :sync_to
  # :type is reserved for STI

  has_one :user

  def fetchable_fields
    if current_user == _model
      super
    else
      super - [:token]
    end
  end
end
