class TheTvdbService
  class NotFound < StandardError; end

  BASE_URL = 'https://api.thetvdb.com'.freeze
  API_KEY = ENV['THE_TVDB_API_KEY'].freeze

  # @return [ActiveRecord::Relation<Mapping>] a scope of Mappings to shows with missing thumbnails
  def self.missing_thumbnails
    Mapping.where(external_site: 'thetvdb')
           .joins(<<-SQL)
             LEFT OUTER JOIN episodes
             ON mappings.item_id = episodes.media_id
             AND mappings.item_type = episodes.media_type
           SQL
           .where(episodes: { thumbnail_file_name: nil }).distinct
  end

  # @return [ActiveRecord::Relation<Mapping>] a scope of Mappings to shows which are airing
  def self.currently_airing
    Mapping.where(external_site: 'thetvdb')
           .joins('LEFT OUTER JOIN anime ON mappings.item_id = anime.id')
           .merge(Anime.current)
  end

  def initialize(mappings)
    @mappings = mappings
  end

  # Import data from TVDB for the Mappings which were passed into the initializer
  def import!
    pluck_mappings(@mappings)['Anime'].each do |(anime_id, tvdb_id)|
      anime = Anime.find(anime_id)
      series_id, season_number = tvdb_id.split('/')
      begin
        series = get_series(series_id)
        episodes = get_episodes(series_id, season_number)
      rescue NotFound
        anime.mappings.where(external_id: tvdb_id).destroy!
        next
      end

      next unless episodes

      next if anime.episode_count && (anime.episode_count - episodes.count).abs > 2
      anime.update_unit_count_guess(episodes.count)

      # creating/updating the episode
      process_series_data(series, anime)
      process_episode_data(episodes, anime, series_id)
    end
  end

  # Uses the TVDB API to trade our API Key for an API Token and then memoizes it
  # @return [String] the TVDB API token
  def api_token
    return @api_token if @api_token

    response = http.post('/login') do |req|
      req.body = { apikey: API_KEY }.to_json
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
    end

    raise "#{response.status}: API Key is invalid." unless response.success?

    @api_token = JSON.parse(response.body)['token']
  end

  # Makes a GET request to the TVDB API
  def get(path)
    response = http.get(path) do |req|
      req.headers['Accept'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{api_token}"
    end

    raise NotFound if response.status == 404
    raise 'TVDB Error' unless response.success?

    JSON.parse(response.body)
  end

  def pluck_mappings(data)
    return if data.blank?

    data.pluck(:item_type, :item_id, :external_id)
        .each_with_object({}) do |(item_type, item_id, external_id), acc|
          acc[item_type] ||= {}
          acc[item_type][item_id] ||= external_id
        end
  end

  def get_episodes(series_id, season_number)
    get("/series/#{series_id}/episodes/query?airedSeason=#{season_number || 1}")['data']
  end

  def get_series(series_id)
    get("/series/#{series_id}")['data']
  end

  def process_episode_data(episodes, media, tvdb_series_id)
    episodes.each do |tvdb_episode|
      row = Row.new(media, tvdb_episode, tvdb_series_id)
      row.update_episode
    end
  end

  def process_series_data(series, media)
    return if media.release_schedule.present?
    return if series['airsTime'].blank? || series['airsDayOfWeek'].blank?

    # Go back a day from the supposed start time since it can be wrong
    start_date = media.start_date.in_time_zone('Japan') - 23.hours
    schedule = IceCube::Schedule.new(start_date, duration: media.episode_length.minutes) do |s|
      time = Time.parse(series['airsTime'])
      s.add_recurrence_rule(
        IceCube::Rule.weekly
          .day(series['airsDayOfWeek'].downcase.to_sym)
          .hour_of_day(time.hour)
          .minute_of_hour(time.min)
          .count(media.episode_count)
      )
    end
    media.update!(release_schedule: schedule)
  end

  private

  def http
    @http ||= Faraday.new(url: BASE_URL)
  end
end
