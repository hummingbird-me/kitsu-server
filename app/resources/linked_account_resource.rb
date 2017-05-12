class LinkedAccountResource < BaseResource
  include STIResource

  model_hint model: LinkedAccount::MyAnimeList
  model_hint model: LinkedAccount::YoutubeChannel

  attributes :external_user_id, :token, :share_to, :share_from, :sync_to,
    :disabled_reason

  has_one :user
  has_many :library_entry_logs

  filters :user_id
end
