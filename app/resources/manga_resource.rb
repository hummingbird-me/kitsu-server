# frozen_string_literal: true

class MangaResource < MediaResource
  attributes :chapter_count, :volume_count, :serialization
  attribute :manga_type # DEPRECATED

  # ElasticSearch hookup
  index MediaIndex::Manga
  query :chapter_count, MediaResource::NUMERIC_QUERY

  has_many :chapters
  has_many :manga_characters
  has_many :manga_staff

  def self._search_service
    MangaSearchService if Flipper[:typesense_manga_search].enabled?(User.current)
  end
end
