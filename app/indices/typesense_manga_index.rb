# frozen_string_literal: true

class TypesenseMangaIndex < TypesenseBaseIndex
  SAVE_FREQUENCIES = {
    'id' => 1,
    'poster_image_data' => 1,
    'titles' => 1,
    'canonical_title' => 1,
    'abbrevated_titles' => 1,
    'description' => 1,
    'chapter_count' => 1,
    'volume_count' => 1,
    'age_rating' => 1,
    'subtype' => 1,
    'start_date' => 1,
    'end_date' => 1,
    'user_count' => 0.1,
    'favorites_count' => 0.1,
    'average_rating' => 0.1
  }.freeze
  include TypesenseMediaIndex

  index_name 'manga'

  schema do
    field 'chapter_count', type: 'int32', facet: true, optional: true
    field 'volume_count', type: 'int32', facet: true, optional: true
  end

  def self.should_sync?(changes)
    [*SAVE_FREQUENCIES.values_at(*changes.keys), 0].compact.max >= rand
  end

  def self.search_key
    ENV.fetch('TYPESENSE_MANGA_SEARCH_KEY', nil)
  end

  def index(ids)
    Manga.where(id: ids).includes(:media_categories, :genres).find_each do |manga|
      titles = manga.titles_list

      yield({
        id: manga.id.to_s,
        poster_image: format_image(manga.poster_image_attacher),
        canonical_title: titles.canonical,
        romanized_title: titles.romanized,
        original_title: titles.original,
        translated_title: titles.translated,
        alternative_titles: titles.alternatives.compact,
        titles: titles.localized,
        start_date: format_date(manga.start_date),
        end_date: format_date(manga.end_date),
        status: manga.status,
        age_rating: manga.age_rating,
        subtype: manga.subtype,
        user_count: manga.user_count,
        favorites_count: manga.favorites_count,
        average_rating: manga.average_rating,
        categories: manga.media_categories.map(&:category_id),
        genres: manga.genres.ids,
        chapter_count: manga.chapter_count,
        volume_count: manga.volume_count,
        created_at: format_date(manga.created_at)
      }.compact)
    end
  end
end
