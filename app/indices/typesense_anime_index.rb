# frozen_string_literal: true

class TypesenseAnimeIndex < TypesenseBaseIndex
  SAVE_FREQUENCIES = {
    'id' => 1,
    'titles' => 1,
    'canonical_title' => 1,
    'abbrevated_titles' => 1,
    'description' => 1,
    'total_length' => 1,
    'episode_count' => 1,
    'episode_length' => 1,
    'age_rating' => 1,
    'subtype' => 1,
    'start_date' => 1,
    'end_date' => 1,
    'user_count' => 0.1,
    'favorites_count' => 0.1,
    'average_rating' => 0.1
  }.freeze
  include TypesenseMediaIndex

  index_name 'anime'

  schema do
    field 'start_cour', type: 'object', optional: true
    field 'start_cour.year', type: 'int32', facet: true, optional: true
    field 'start_cour.season', type: 'string', facet: true, optional: true

    field 'episode_count', type: 'int32', facet: true, optional: true
    field 'episode_length', type: 'int32', facet: true, optional: true
    field 'total_length', type: 'int32', facet: true, optional: true

    field 'streaming_sites', type: 'string[]', facet: true, optional: true
    field 'streaming_links', type: 'object[]', facet: true, optional: true
    field 'streaming_links.site', type: 'int32[]', facet: true, optional: true
    field 'streaming_links.dubs', type: 'string[]', facet: true, optional: true
    field 'streaming_links.subs', type: 'string[]', facet: true, optional: true
    field 'streaming_links.regions', type: 'string[]', facet: true, optional: true
  end

  def self.should_sync?(changes)
    [*SAVE_FREQUENCIES.values_at(*changes.keys), 0].compact.max >= rand
  end

  def self.search_key
    ENV.fetch('TYPESENSE_ANIME_SEARCH_KEY', nil)
  end

  def index(ids)
    Anime.where(id: ids).includes(
      :media_categories, :genres, streaming_links: [:streamer]
    ).find_each do |anime|
      titles = anime.titles_list

      yield({
        id: anime.id.to_s,
        canonical_title: titles.canonical,
        romanized_title: titles.romanized,
        original_title: titles.original,
        translated_title: titles.translated,
        alternative_titles: titles.alternatives.compact,
        titles: titles.localized,
        descriptions: anime.description,
        start_date: format_date(anime.start_date),
        end_date: format_date(anime.end_date),
        start_cour: {
          year: anime.season_year,
          season: anime.season
        },
        age_rating: anime.age_rating,
        subtype: anime.subtype,
        user_count: anime.user_count,
        favorites_count: anime.favorites_count,
        average_rating: anime.average_rating,
        categories: anime.media_categories.map(&:category_id),
        genres: anime.genres.ids,
        streaming_sites: anime.streaming_links.map(&:streamer_id),
        streaming_links: anime.streaming_links.filter_map do |link|
          if link.present?
            {
              site: link.streamer_id,
              dubs: link.dubs,
              subs: link.subs,
              regions: link.regions
            }
          end
        end,
        episode_count: anime.episode_count,
        episode_length: anime.episode_length,
        total_length: anime.total_length,
        created_at: format_date(anime.created_at)
      }.compact)
    end
  end
end
