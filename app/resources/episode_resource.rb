class EpisodeResource < BaseResource
  caching

  attribute :synopsis # DEPRECATED
  def synopsis
    description
  end

  attribute :description
  def description
    _model.description['en']
  end

  attributes :titles, :canonical_title, :season_number, :number, :relative_number,
    :airdate, :length
  attribute :thumbnail, format: :shrine_attachment, delegate: :thumbnail_attacher

  has_one :media, polymorphic: true
  has_many :videos

  filters :media_id, :media_type
  filter :number, verify: ->(values, _context) { values.map(&:to_i) }

  def length
    _model.length / 60 if _model.length
  end
end
