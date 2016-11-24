require 'unlimited_paginator'

class LibraryEntryResource < BaseResource
  attributes :status, :progress, :reconsuming, :reconsume_count, :notes,
    :private, :rating, :updated_at

  filters :user_id, :media_id, :media_type, :status

  filter :status, apply: ->(records, value, _options) {
    value = LibraryEntry.statuses[value] || value
    records.where(status: value)
  }

  has_one :user
  has_one :review
  has_one :media, polymorphic: true
  has_one :unit, polymorphic: true

  paginator :unlimited
end
