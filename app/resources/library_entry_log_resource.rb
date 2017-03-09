class LibraryEntryLogResource < BaseResource
  immutable
  attributes :media_type, :media_id, :progress, :rating, :reconsume_count,
    :reconsuming, :status, :volumes_owned, :action_performed, :sync_status

  has_one :linked_account

  filters :linked_account_id
end
