class LibraryEntryLogResource < BaseResource
  immutable
  attributes :progress, :rating, :reconsume_count,
    :reconsuming, :status, :volumes_owned, :action_performed, :sync_status

  has_one :linked_account
  has_one :media, polymorphic: true

  filters :linked_account_id
end
