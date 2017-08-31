class TheTvdbService
  BASE_URL = 'https://api.thetvdb.com'.freeze
  API_KEY = ENV['THE_TVDB_API_KEY'].freeze

  # This will create new mappings that combine series/season together.
  def create_tvdb_mapping!
    return if mapping_data.blank?

    mapping_data['Anime'].each do |media_ids|
      # set the media_id (this is for our database)
      media_id = media_ids[0]
      series_id = media_ids[1]['thetvdb/series']
      season_id = media_ids[1]['thetvdb/season']

      response = get(build_episode_path(series_id, season_id))

      next if response.code == 404
      raise 'TVDB Error' unless response.success?

      response = JSON.parse(response.body)

      # Filters depending on if a airedSeasonID is present
      response['data'] = season_filter(response['data'], season_id)

      season_number = find_season_number(response['data'])
      create_mapping(media_id, series_id, season_number)
    end
  end

  # grabs all Mappings
  def mapping_data
    @md ||= Mapping.where(external_site: %w[thetvdb/series thetvdb/season])
                   .pluck(:item_type, :item_id, :external_site, :external_id)
                   .each_with_object({}) do |(item_type, item_id, external_site, external_id), acc|
                     acc[item_type] ||= {}
                     acc[item_type][item_id] ||= {}
                     acc[item_type][item_id][external_site] = external_id
                   end
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
    Typhoeus::Request.get(
      build_url(url),
      headers: {
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{api_token}"
      }
    )
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

  def season_filter(episodes, season_id)
    return episodes.select { |ep| ep['airedSeason'].present? } if season_id.blank?

    episodes.select { |ep| ep['airedSeasonID'] == season_id.to_i && ep['airedSeason'].present? }
  end

  def find_season_number(episodes)
    episodes.count.zero? ? 1 : episodes.first['airedSeason']
  end

  def create_mapping(media_id, series_id, season_number)
    mapping = Mapping.where(
      external_site: 'thetvdb',
      item_id: media_id,
      item_type: 'Anime'
    ).first_or_initialize

    mapping.external_id = "#{series_id}/#{season_number}"
    mapping.save!
  end
end
