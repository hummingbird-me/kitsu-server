class LinkedAccountResource < BaseResource
  model_hint model: LinkedAccount::MyAnimeList

  attributes :external_user_id, :token, :share_to,
    :share_from, :sync_to, :kind
  # :kind is aliased to :type in LinkedAccount

  has_one :user

  filters :user_id

  before_save do
    @model.kind = "LinkedAccount::#{@model.kind}"
  end
end
