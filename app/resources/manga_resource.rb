class MangaResource < MediaResource
  attributes :subtype, :chapter_count, :volume_count, :serialization
  attribute :manga_type # DEPRECATED

  # ElasticSearch hookup
  index MediaIndex::Manga
end
