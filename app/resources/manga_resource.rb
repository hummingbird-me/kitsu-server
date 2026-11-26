# frozen_string_literal: true

class MangaResource < MediaResource
  attributes :chapter_count, :volume_count, :serialization
  attribute :manga_type # DEPRECATED

  # Typesense hookup
  search_with MangaSearchService
  query :chapter_count, MediaResource::NUMERIC_QUERY

  has_many :chapters
  has_many :manga_characters
  has_many :manga_staff
end
