class ChapterResource < BaseResource
  caching

  attribute :synopsis # DEPRECATED
  def synopsis
    description
  end

  attribute :description
  def description
    _model.description['en']
  end

  attributes :titles, :canonical_title, :volume_number, :number,
    :published, :length
  attribute :thumbnail, format: :attachment

  has_one :manga

  filters :manga_id
  filter :number, verify: ->(values, _context) { values.map(&:to_i) }
end
