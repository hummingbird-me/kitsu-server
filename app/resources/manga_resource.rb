class MangaResource < MediaResource
  attributes :chapter_count, :volume_count, :serialization
  attribute :manga_type # DEPRECATED

  # ElasticSearch hookup
  index MediaIndex::Manga
  query :chapter_count, MediaResource::NUMERIC_QUERY

  has_many :chapters
  has_many :manga_characters
  has_many :manga_staff
end
