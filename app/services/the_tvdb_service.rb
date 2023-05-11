# frozen_string_literal: true

class TheTvdbService
  class NotFound < StandardError; end
  class MappingError < StandardError; end

  BASE_URL = 'https://api.thetvdb.com'
  API_KEY = ENV['THE_TVDB_API_KEY'].freeze

  # @return [ActiveRecord::Relation<Mapping>] a scope of Mappings to shows with missing thumbnails
  def self.missing_thumbnails
    Mapping.where(external_site: 'thetvdb')
           .joins(Arel.sql(<<-SQL))
             LEFT OUTER JOIN episodes
             ON mappings.item_id = episodes.media_id
             AND mappings.item_type = episodes.media_type
           SQL
           .where(episodes: { thumbnail_file_name: nil }).distinct
  end

  # @return [ActiveRecord::Relation<Mapping>] a scope of Mappings to shows which are airing
  def self.currently_airing
    Mapping.where(external_site: 'thetvdb')
           .joins(Arel.sql('LEFT OUTER JOIN anime ON mappings.item_id = anime.id'))
           .merge(Anime.current)
  end

  def initialize(mappings)
    @mappings = mappings
  end

  # Import data from TVDB for the Mappings which were passed into the initializer
  def import!
    each_mapping do |anime, series_id, season_number|
      begin
        series = get_series(series_id)
        episodes = get_episodes(series_id, season_number).to_a
      rescue NotFound
        anime.mappings.where(external_id: tvdb_id).first.destroy!
        next
      end

      next unless episodes
      next if anime.episode_count && (anime.episode_count - episodes.count).abs > 2

      if anime.episode_count
        episodes = episodes[0..anime.episode_count - 1] if anime.episode_count
      else
        anime.update_unit_count_guess(episodes.count)
      end

      # creating/updating the episode
      process_series_data(series, anime)
      process_episode_data(episodes, anime, series_id)
    end
  rescue MappingError
    anime.mappings.where(external_id)
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

  def each_mapping
    (pluck_mappings(@mappings)['Anime'] || []).each do |(anime_id, tvdb_id)|
      anime = Anime.find(anime_id)
      series_id, season_numbers = parse_identifier(tvdb_id)

      yield anime, series_id, season_numbers
    end
  end

  def pluck_mappings(data)
    return if data.blank?

    data.pluck(:id, :item_type, :item_id, :external_id)
        .each_with_object({}) do |(item_type, item_id, external_id), acc|
          acc[item_type] ||= {}
          acc[item_type][item_id] ||= external_id
        end
  end

  def get_episodes(series_id, season_numbers)
    Enumerator.new do |y|
      page = 1
      template = Addressable::Template.new('/series/{series_id}/episodes/query{?query*}')
      season_number = season_numbers if /\A\d+\z/.match?(season_number)

      loop do
        url = template.expand(series_id:, query: {
          airedSeason: season_number,
          page:
        }.compact)
        response = get(url)
        response['data'].each do |row|
          y << row if season_numbers.include?(row['airedSeason'])
        end
        page = response.dig('links', 'next')
        break unless page
      end
    end
  end

  def get_series(series_id)
    get("/series/#{series_id}")['data']
  end

  def process_episode_data(episodes, media, tvdb_series_id)
    first_number = episodes.first['airedEpisodeNumber']
    episodes.each do |tvdb_episode|
      row = Row.new(media, tvdb_episode, tvdb_series_id, first_number)
      row.update_episode
    end
  end

  def process_series_data(series, media)
    return if media.release_schedule.present?
    return if series['airsTime'].blank? || series['airsDayOfWeek'].blank?

    schedule = parse_schedule(media, series['airsDayOfWeek'], series['airsTime'])
    media.update!(release_schedule: schedule)
  rescue StandardError => e
    Sentry.capture_exception(e)
  end

  private

  def parse_identifier(id)
    series_id, season_numbers = id.split('/')

    case season_numbers
    when nil # No season provided
      [series_id, [1]]
    when /\A\d+\z/ # Single season (8)
      [series_id, [season_numbers.to_i]]
    when /\A\d+-\d+\z/ # Season range (1-7)
      season_range = Range.new(*season_numbers.split('-').map(&:to_i))
      [series_id, season_range.to_a]
    when /\A\d+(,\d+)*\z/ # Season list (1,2,3,4,5)
      season_list = season_numbers.split(',').map(&:to_i)
      [series_id, season_list]
    end
  end

  def parse_schedule(media, day_of_week, time)
    # Go back a day from the supposed start time since it can be wrong
    start_date = media.start_date.in_time_zone('Japan') - 23.hours
    duration = media.episode_length&.minutes || 23

    IceCube::Schedule.new(start_date, duration:) do |s|
      recurrence = if day_of_week.casecmp('daily').zero?
        IceCube::Rule.daily
      else
        IceCube::Rule.weekly.day(day_of_week.downcase.to_sym)
      end
      time = Time.parse(time)
      recurrence = recurrence.hour_of_day(time.hour).minute_of_hour(time.min)
      recurrence = recurrence.count(media.episode_count) if media.episode_count

      s.add_recurrence_rule(recurrence)
    end
  end

  def http
    @http ||= Faraday.new(url: BASE_URL)
  end
end
