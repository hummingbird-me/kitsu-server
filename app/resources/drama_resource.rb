class DramaResource < MediaResource
  include EpisodicResource

  attributes :subtype, :youtube_video_id

  # ElasticSearch hookup
  index MediaIndex::Drama
end
