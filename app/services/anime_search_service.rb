# frozen_string_literal: true

class AnimeSearchService < TypesenseSearchService
  # Runs the search and returns the list of matching library entries in order by
  # their relevance to the queries.
  #
  # @return [Array<Anime>] the list of matching anime
  def to_a
    result_ids.map do |id|
      result_media[id.to_i]
    end
  end

  def query_results
    @query_results ||= query.include_fields(:id).load
  end

  def sfw
    @sfw = true
    self
  end

  private

  def result_media
    @result_media ||= Anime.find(result_ids).index_by(&:id)
  end

  def result_ids
    @result_ids ||= query_results.hits.map { |res| res.document['id'] }
  end

  def query
    @query ||= begin
      query = TypesenseAnimeIndex.search(
        query: filters[:text]&.join(' ') || '',
        query_by: {
          'canonical_title' => 100,
          'titles.*' => 90,
          'alternative_titles' => 90,
          'descriptions.*' => 80
        }
      )
      query = apply_filters_to(query)
      query = apply_order_to(query)
      query = apply_limit_to(query)
      query = apply_offset_to(query)
      query
    end
  end

  def apply_filters_to(scope)
    scope = apply_sfw_filter_for(scope)
    scope = apply_numeric_filter_for(scope, :average_rating)
    scope = apply_numeric_filter_for(scope, :user_count)
    scope = apply_auto_filter_for(scope, :subtype)
    scope = apply_auto_filter_for(scope, :status)
    scope = apply_numeric_filter_for(scope, :episode_count)
    scope = apply_numeric_filter_for(scope, :episode_length)
    scope = apply_auto_filter_for(scope, :age_rating)
    scope = apply_auto_filter_for(scope, 'start_cour.season', filter_param: :season)
    scope = apply_numeric_filter_for(scope, 'start_cour.year', filter_param: :season_year)
    scope = apply_numeric_filter_for(scope, 'start_date.year', filter_param: :year)
    scope = apply_genres_filter_for(scope)
    scope = apply_categories_filter_for(scope)
    apply_streamers_filter_for(scope)
  end

  def apply_order_to(scope)
    return scope unless orders

    # Replace _text_match with _text_match(buckets: 6),user_count in the same direction
    # This generally gives significantly better results for media searches
    improved_orders = orders.flat_map do |field, direction|
      case field
      when '_text_match'
        [['_text_match(buckets: 6)', direction], ['user_count', direction]]
      when 'start_date', 'created_at'
        [["#{field}.timestamp", direction]]
      else
        [[field, direction]]
      end
    end
    scope.sort(improved_orders.to_h)
  end

  def apply_sfw_filter_for(scope)
    return scope unless @sfw

    scope.filter('age_rating:=[G,PG,R]')
  end

  def apply_genres_filter_for(scope)
    return scope if filters[:genres].blank?

    genre_ids = Genre.where(slug: filters[:genres]).ids
    # Implemented as a set of AND filters
    scope.filter(genre_ids.map { |id| "genres:=#{id}" })
  end

  def apply_categories_filter_for(scope)
    return scope if filters[:categories].blank?

    category_ids = Category.where(slug: filters[:categories]).ids
    # Implemented as a set of AND filters
    scope.filter(category_ids.map { |id| "categories:=#{id}" })
  end

  def apply_streamers_filter_for(scope)
    return scope if filters[:streamers].blank?

    streamer_ids = Streamer.by_name(filters[:streamers]).ids
    scope.filter(auto_query_for('streaming_sites', streamer_ids))
  end
end
