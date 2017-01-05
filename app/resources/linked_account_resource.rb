class LinkedAccountResource < BaseResource
  model_hint model: LinkedAccount::MyAnimeList

  attribute :token
  attributes :external_user_id, :share_to, :share_from, :sync_to
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
