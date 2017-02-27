class DramaResource < MediaResource
  include EpisodicResource

  attributes :subtype, :youtube_video_id
  has_many :drama_characters
  has_many :drama_staff

  # ElasticSearch hookup
  index MediaIndex::Drama
end
