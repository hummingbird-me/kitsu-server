require 'unlimited_paginator'

class LibraryEntryResource < BaseResource
  caching

  attributes :status, :progress, :reconsuming, :reconsume_count, :notes,
    :private, :rating, :updated_at

  filters :user_id, :media_id, :media_type, :status

  filter :status, apply: ->(records, values, _options) {
    statuses = LibraryEntry.statuses.values_at(*values).compact
    statuses = values if statuses.empty?
    records.where(status: statuses)
  }

  filter :since, apply: ->(records, values, _options) {
    time = values.join.to_time
    records.where('updated_at >= ?', time)
  }

  has_one :user
  has_one :review
  has_one :media, polymorphic: true
  has_one :unit, polymorphic: true, eager_load_on_include: false
  has_one :next_unit, polymorphic: true, eager_load_on_include: false

  paginator :unlimited
end
