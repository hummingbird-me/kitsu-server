# frozen_string_literal: true

class TypesenseMangaIndex < TypesenseBaseIndex
  include TypesenseMediaIndex

  index_name 'manga'

  schema do
    field 'chapter_count', type: 'int32', facet: true, optional: true
    field 'volume_count', type: 'int32', facet: true, optional: true
  end

  def index(ids)
    Manga.where(id: ids).includes(:media_categories, :genres).find_each do |manga|
      titles = manga.titles_list

      yield({
        id: manga.id.to_s,
        canonical_title: titles.canonical,
        romanized_title: titles.romanized,
        original_title: titles.original,
        translated_title: titles.translated,
        alternative_titles: titles.alternatives.compact,
        titles: titles.localized,
        descriptions: manga.description,
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
        volume_count: manga.volume_count
      }.compact)
    end
  end
end
