class MangaResource < MediaResource
  attributes :manga_type, :chapter_count, :volume_count, :serialization

  # ElasticSearch hookup
  index MediaIndex::Manga
end
