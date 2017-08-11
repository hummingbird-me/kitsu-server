# Service to sync Hulu API with Kitsu
class HuluMappingService
  HULU_URL = 'https://distribution.hulu.com/api/v1/'.freeze

  attr_reader :since

  # Initialize services with GetStream webhook request
  def initialize(since = nil)
    @since = since
  end

  # Grabs all available series from hulu, maps them as wel as their episodes
  def sync_series_and_episodes
    ActiveRecord::Base.logger = Logger.new(nil)
    Chewy.strategy(:bypass)
    offset = 0
    limit = 10_000
    series_res = Typhoeus.get(
      "#{HULU_URL}/series?guid=#{guid}&primary_category=animation&offset=#{offset}&limit=#{limit}"
    )
    hulu_anime = JSON.parse(series_res.body)['results']
    hulu_anime.each do |item|
      item = item.deep_symbolize_keys
      series_id = item[:id]
      title = item[:name].titleize
      mapping_object = {
        title: title
      }
      kitsu_anime = Mapping.guess('Anime', mapping_object)
      next unless kitsu_anime
      # creating mapping with series to kitsu anime
      kitsu_anime.mappings.where(
        external_site: 'hulu',
        external_id: series_id
      ).first_or_create

      # grab available episodes from hulu with anime
      since_param = since.advance(hours: -24).strftime('%F') if since
      episodes_url = "#{HULU_URL}/assets?guid=#{guid}&series_id=#{series_id}"
      episodes_url += "&type=episode&limit=#{limit}"
      episodes_url += "&since=#{since_param}" if since
      episode_res = Typhoeus.get(
        episodes_url
      )
      hulu_episodes = JSON.parse(episode_res.body)
      hulu_ep_hash = hulu_episodes.each_with_object({}) do |ep, acc|
        ep = ep.deep_symbolize_keys
        acc[ep[:number]] = ep
      end

      # create episode mapping for each episode on kitsu if hulu has it
      kitsu_anime.episodes.each do |ep|
        next unless hulu_ep_hash.key?(ep.number)
        Mapping.where(
          media: ep,
          external_site: 'hulu',
          external_id: hulu_ep_hash[ep.number][:site_id]
        ).first_or_create
      end
    end
  end

  def guid
    ENV['HULU_GUID']
  end
end
