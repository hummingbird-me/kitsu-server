class TheTvdbService
  BASE_URL = 'https://api.thetvdb.com'.freeze
  API_KEY = ENV['THE_TVDB_API_KEY'].freeze

  def initialize
    @token = api_token
  end

  def nightly_import!
  end

  def weekly_import!
    return if missing_data.empty?

    missing_data['Anime'].each do |media_ids|
      media_id = media_ids[0]

      # check if the external_sites exist.
      series_id = media_ids[1].try(:[], 'thetvdb/series')
      season_id = media_ids[1].try(:[], 'thetvdb/season')

      # will get the data from tvdb
      # TODO: need to figure out how to skip if it returns nothing (404)
      # TODO: will also need to add a check if episode_count and data.count are equal.
      # will most likly break this out of 1 method.
      get(build_episode_path(series_id, season_id)).try(:[], 'data')&.each do |tvdb_episode|
        # this is only a check if season_id actually exists.
        # otherwise the data is already filtered.
        next if season_id.present?
        next unless tvdb_episode['airedSeasonID'] == season_id
        next if tvdb_episode['absoluteNumber'].nil?

        row = Row.new(media_id, tvdb_episode)
        row.update_episode!
        # row.update_mapping!
      end
    end
  end

  def missing_data
    @md ||= Mapping.where(external_site: %w[thetvdb/series thetvdb/season])
                   .joins('LEFT OUTER JOIN episodes ON mappings.media_id = episodes.media_id AND mappings.media_type = episodes.media_type')
                   .where(episodes: { thumbnail_file_name: nil })
                   .distinct.pluck(:media_type, :media_id, :external_site, :external_id)
                   .each_with_object({}) { |(media_type, media_id, external_site, external_id), acc|
                     acc[media_type] ||= {}
                     acc[media_type][media_id] ||= {}
                     acc[media_type][media_id][external_site] = external_id
                   }
  end

  def api_token
    body = { apikey: API_KEY }.to_json

    request = Typhoeus::Request.new(build_url('/login'),
      method: :post,
      body: body,
      headers: {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      })

    response = request.run

    return JSON.parse(response.body)['token'] unless response.code != 200

    # throw some error and abort.
  end

  def get(url)
    request = Typhoeus::Request.new(build_url(url),
      method: :get,
      headers: {
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{@token}"
      })

    response = request.run

    return JSON.parse(response.body) unless response.code != 200

    # need to handle 404, might just return response and check code above.
  end

  def build_url(url)
    "#{BASE_URL}#{url}"
  end

  def build_episode_path(series, season)
    path = "/series/#{series}/episodes"
    path += '/query?airedSeason=1' unless season

    path
  end
end
