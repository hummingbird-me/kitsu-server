class LinkedProfileResource < BaseResource
  attribute :token
  attributes :external_user_id, :url, :share_to, :share_from

  has_one :user
  has_one :linked_site

  def fetchable_fields
    if current_user == _model
      super
    else
      super - [:token]
    end
  end
end
