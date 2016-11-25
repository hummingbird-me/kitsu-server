class EpisodeResource < BaseResource
  attributes :titles, :canonical_title, :season_number, :number, :synopsis,
    :airdate, :length
  attribute :thumbnail, format: :attachment

  has_one :media, polymorphic: true

  filter :media_id, :media_type
  filter :number, MediaResource::NUMERIC_QUERY
end
