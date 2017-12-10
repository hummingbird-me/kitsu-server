class TheTvdbService
  class NotFound < StandardError; end

  BASE_URL = 'https://api.thetvdb.com'.freeze
  API_KEY = ENV['THE_TVDB_API_KEY'].freeze

  def initialize(set_name)
    @set_name = set_name
  end

  def import!
    data = query_data
    return if data.blank?
    data['Anime'].each do |(anime_id, mappings)|
      series_id, season_id = mappings['thetvdb'].split('/')

      response = get(build_episode_path(series_id, season_id))
      next unless response

      # update the episode count if it does not exist.
      tvdb_episodes_count = response['data'].count
      anime = Anime.find(anime_id)
      anime.update_unit_count_guess(tvdb_episodes_count)
      # we don't want to add their data if the episode counts don't match up
      # TODO: we should log this because it would be good to double check.
      next unless [anime.episode_count, anime.episode_count_guess].include?(tvdb_episodes_count)

      # creating/updating the episode
      process_episode_data(response, anime_id, series_id)
    end
  end

  def missing_thumbnails
    return @missing_thumbnails if @missing_thumbnails

    data = Mapping.where(external_site: 'thetvdb')
                  .joins(<<-SQL)
                    LEFT OUTER JOIN episodes
                    ON mappings.item_id = episodes.media_id
                    AND mappings.item_type = episodes.media_type
                  SQL
                  .where(episodes: { thumbnail_file_name: nil }).distinct

    @missing_thumbnails = format_data(data)
  end

  def currently_airing
    return @currently_airing if @currently_airing

    data = Mapping.where(external_site: %w[thetvdb/series thetvdb/season])
                  .joins('LEFT OUTER JOIN anime ON mappings.item_id = anime.id')
                  .merge(Anime.current)

    @currently_airing = format_data(data)
  end

  def api_token
    return @token if @token

    body = { apikey: API_KEY }.to_json

    response = Typhoeus::Request.post(
      build_url('/login'),
      body: body,
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    )

    if response.success?
      @token = JSON.parse(response.body)['token']
      return @token
    end

    raise "#{response.code}: apikey/api token is invalid."
  end

  def get(url)
    response = Typhoeus::Request.get(
      build_url(url),
      headers: {
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{api_token}"
      }
    )
    raise NotFound if response.code == 404
    raise 'TVDB Error' unless response.success?

    JSON.parse(response.body)
  rescue NotFound
    false
  end

  def format_data(data)
    return if data.blank?

    data.pluck(:item_type, :item_id, :external_site, :external_id)
        .each_with_object({}) do |(item_type, item_id, external_site, external_id), acc|
          acc[item_type] ||= {}
          acc[item_type][item_id] ||= {}
          acc[item_type][item_id][external_site] = external_id
        end
  end

  def query_data
    return unless %i[currently_airing missing_thumbnails].include?(@set_name)
    send(@set_name)
  end

  def build_url(url)
    "#{BASE_URL}#{url}"
  end

  def build_episode_path(series_id, season_number)
    season_number ||= 1
    path = "/series/#{series_id}/episodes"
    # I am assuming that no show has more than 25 seasons
    # and that the airedSeasonID is going to always be greater than that.
    # and we will catch any errors when we send the response.
    path += "/query?airedSeason=#{season_number}" if season_number.to_i < 25
    path
  end

  def process_episode_data(response, media_id, tvdb_series_id)
    response['data'].each do |tvdb_episode|
      row = Row.new(media_id, tvdb_episode, tvdb_series_id)
      row.update_episode!
    end
  end
end
