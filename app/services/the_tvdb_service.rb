class TheTvdbService
  BASE_URL = 'https://api.thetvdb.com'.freeze
  API_KEY = ENV['THE_TVDB_API_KEY'].freeze

  attr_accessor :media_id

  def initialize
    @token = api_token
  end

  # This will update all mappings to have a season number
  # This should be run ONLY ONCE, unless we import data from somewhere else.
  def update_mapping_seasons!
    return if mapping_data.blank?

    mapping_data['Anime'].each do |media_ids|
      # set the media_id (this is for our database)
      self.media_id = media_ids[0]
      series_id = media_ids[1]['thetvdb/series'][1]
      season_id = media_ids[1]['thetvdb/season'][1] if media_ids[1].try(:[], 'thetvdb/season')

      response = get(build_episode_path(series_id, season_id))

      unless response.code == 200
        # will be deleted the mappings if their is a 404 response code
        raise 'Something bad has happened related to TVDB.' unless response.code == 404

        # delete series mapping
        series_id = media_ids[1]['thetvdb/series'][0]
        Mapping.delete(series_id)

        # delete season mapping if it exists
        if season_id
          season_id = media_ids[1]['thetvdb/season'][0]
          Mapping.delete(season_id)
        end

        next
      end

      response = JSON.parse(response.body)

      # Filters depending on if a airedSeasonID is present
      if season_id.present?
        response['data'] = response['data'].select do |ep|
          ep['airedSeasonID'] == season_id.to_i && ep['airedSeason'].present?
        end
      else
        response['data'] = response['data'].select do |ep|
          ep['airedSeason'].present?
        end
      end

      season_number = response['data'].count.zero? ? 1 : response['data'].first['airedSeason']

      m = Mapping.where(
        external_site: 'thetvdb/season',
        item_id: media_id,
        item_type: 'Anime'
      ).first_or_initialize

      m.external_id = season_number.to_s
      m.save!
    end
  end

  # grabs all Mappings
  def mapping_data
    @md ||= Mapping.where(external_site: %w[thetvdb/series thetvdb/season])
                   .pluck(:id, :item_type, :item_id, :external_site, :external_id)
                   .each_with_object({}) { |(id, item_type, item_id, external_site, external_id), acc|
                     acc[item_type] ||= {}
                     acc[item_type][item_id] ||= {}
                     acc[item_type][item_id][external_site] = [id, external_id]
                   }
  end

  def api_token
    return @token if @token.present?

    body = { apikey: API_KEY }.to_json

    response = Typhoeus::Request.post(
      build_url('/login'),
      body: body,
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    )

    return JSON.parse(response.body)['token'] if response.code == 200

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

  def build_episode_path(series, season_number)
    season_number ||= 1
    path = "/series/#{series}/episodes"
    # I am assuming that no show has more than 25 seasons
    # and that the airedSeasonID is going to always be greater than that.
    # and we will catch any errors when we send the response.
    path += "/query?airedSeason=#{season_number}" if season_number.to_i < 25

    path
  end
end
