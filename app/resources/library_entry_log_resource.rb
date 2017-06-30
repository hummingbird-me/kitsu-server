require 'unlimited_paginator'

class LibraryEntryLogResource < BaseResource
  immutable
  paginator :unlimited
  attributes :progress, :rating, :reconsume_count, :reconsuming,
    :status, :volumes_owned, :action_performed, :sync_status, :error_message

  has_one :linked_account
  has_one :media, polymorphic: true

  filters :linked_account_id, :sync_status
end
