require 'library_paginator'

class LibraryEntryResource < BaseResource
  TITLE_SORT = /\A([^\.]+)\.titles\.([^\.]+)\z/

  class TitleSortableFields
    def initialize(whitelist)
      @whitelist = whitelist
    end

    def include?(key)
      return true if @whitelist.include?(key)
      # Magic match-handling code
      match = TITLE_SORT.match(key.to_s)
      return false unless match
      media, title = match[1..-1]
      return false unless %w[anime manga drama].include?(media.downcase)
      return true if title.casecmp('canonical')
      return false unless /[a-z]{2}(_[a-z]{2})?/ =~ title
      true
    end
  end

  caching

  attributes :status, :progress, :volumes_owned, :reconsuming, :reconsume_count,
    :notes, :private, :reaction_skipped, :progressed_at, :started_at, :finished_at

  filters :user_id, :media_id, :media_type, :status, :anime_id, :manga_id,
    :drama_id

  filter :status, apply: ->(records, values, _options) {
    statuses = LibraryEntry.statuses.values_at(*values).compact
    statuses = values if statuses.empty?
    records.where(status: statuses)
  }

  filter :kind, apply: ->(records, values, _options) {
    records.by_kind(*values)
  }

  filter :since, apply: ->(records, values, _options) {
    time = values.join.to_time
    records.where('library_entries.updated_at >= ?', time)
  }

  filter :following, apply: ->(records, values, _options) {
    records.following(values.join(','))
  }

  has_one :user
  has_one :anime
  has_one :manga
  has_one :drama
  has_one :review, eager_load_on_include: false
  has_one :media_reaction
  has_one :media, polymorphic: true
  has_one :unit, polymorphic: true, eager_load_on_include: false
  has_one :next_unit, polymorphic: true, eager_load_on_include: false

  paginator :library

  search_with LibrarySearchService
  query :title

  # DEPRECATED: These methods are for until all clients have switched to
  # rating_twenty
  attributes :rating, :rating_twenty
  def rating
    ((_model.rating.to_f / 2).floor.to_f / 2).to_s
  end

  def rating=(value)
    return unless value
    _model.rating = value.to_f * 4
  end

  def rating_twenty
    _model.rating
  end

  def rating_twenty=(value)
    _model.rating = value
  end
  # END DEPRECATED

  def self.status_counts(filters, opts = {})
    return if should_query?(filters)
    statuses = LibraryEntry.statuses.invert
    find_records(filters, opts).group(:status).count.transform_keys do |status|
      statuses[status]
    end
  end

  def self.sortable_fields(context)
    fields = super + %i[anime.subtype manga.subtype drama.subtype
                        anime.episode_count manga.chapter_count]
    TitleSortableFields.new(fields)
  end

  def self.apply_sort(records, order_options, context = {})
    # For each requested sort option, decide whether to use the title sort logic
    order_options = order_options.map do |field, dir|
      [(TITLE_SORT =~ field ? :title : :other), field, dir]
    end
    # Combine consecutive sort options of the same type into lists
    order_options = order_options.each_with_object([]) do |curr, acc|
      type, field, dir = curr
      acc << [type, {}] unless acc.last&.first == type
      acc.last[1][field] = dir
    end
    # Send each list to either apply_title_sort or super
    order_options.each do |(type, sorts)|
      records = if type == :title
                  apply_title_sort(records, sorts, context)
                else
                  super(records, sorts, context)
                end
    end
    records
  end

  def self.apply_title_sort(records, order_options, _context = {})
    order_options.each_pair do |field, direction|
      media, title = TITLE_SORT.match(field.to_s)[1..-1]
      direction = direction.upcase

      records = records.joins(<<-EOF.squish)
        LEFT JOIN #{media} AS #{media}_sort
        ON #{media}_sort.id = library_entries.#{media}_id
      EOF

      if title == 'canonical'
        records = records.order(<<~EOF)
          #{media}_sort.titles->canonical_title #{direction}
        EOF
      elsif /[a-z]{2}(_[a-z]{2})?/i =~ title
        records = records.order(<<~EOF.squish)
          COALESCE(
            NULLIF(#{media}_sort.titles->'#{title}', ''),
            NULLIF(#{media}_sort.titles->canonical_title, ''),
            NULLIF(#{media}_sort.titles->'en_jp', '')
          ) #{direction}
        EOF
      end
    end

    records
  end
end
