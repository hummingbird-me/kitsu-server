class ChapterResource < BaseResource
  caching

  attributes :titles, :canonical_title, :volume_number, :number, :synopsis,
    :published, :length
  attribute :thumbnail, format: :attachment

  has_one :manga

  filters :manga_id
  filter :number, verify: ->(values, _context) { values.map(&:to_i) }
end
