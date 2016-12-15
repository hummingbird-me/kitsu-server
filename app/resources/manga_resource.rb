class MangaResource < MediaResource
  attributes :manga_type, :chapter_count, :volume_count, :serialization

  has_many :quotes
  # ElasticSearch hookup
  index MediaIndex::Manga
end
