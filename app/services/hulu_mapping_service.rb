# Service to sync Hulu API with Kitsu
class HuluMappingService
  HULU_URL = 'https://distribution.hulu.com/api/v1/'.freeze

  attr_reader :since

  # Initialize service with optional datetime
  def initialize(since = nil)
    @since = since
  end

  # Grabs all available series from hulu
  def grab_series
    offset = 0
    series_res = Typhoeus.get(
      "#{HULU_URL}/series?guid=#{guid}&primary_category=animation&offset=#{offset}&limit=10000"
    )
    return unless series_res.success?
    JSON.parse(series_res.body)['results']
  end

  # Start of syncing series and episodes on hulu with kitsu anime
  def sync_series_and_episodes
    grab_series&.each do |item|
      item = item.deep_symbolize_keys
      series_id = item[:id]
      title = item[:name].titleize
      kitsu_anime = Mapping.lookup('hulu', series_id)
      kitsu_anime ||= Mapping.guess('Anime', title: title)
      next unless kitsu_anime
      create_mapping(kitsu_anime, series_id)
      hulu_episodes = get_episodes(series_id)
      next unless hulu_episodes
      sync_episodes_for_anime(hulu_episodes, kitsu_anime)
    end
  end

  def create_mapping(kitsu_anime, series_id)
    # creating mapping with series to kitsu anime
    kitsu_anime.mappings.where(
      external_site: 'hulu',
      external_id: series_id
    ).first_or_create
  end

  def get_episodes(series_id)
    # grab available episodes from hulu with anime
    since_param = since.strftime('%F') if since
    ep_url = "#{HULU_URL}/assets?guid=#{guid}&series_id=#{series_id}&type=episode&limit=10000"
    ep_url += "&since=#{since_param}" if since
    episode_res = Typhoeus.get(
      ep_url
    )
    return unless episode_res.success?
    JSON.parse(episode_res.body)
  end

  def sync_episodes_for_anime(hulu_episodes, kitsu_anime)
    hulu_ep_hash = hulu_episodes.each_with_object({}) do |ep, acc|
      ep = ep.deep_symbolize_keys
      acc[ep[:number]] = ep
    end

    # create episode mapping for each episode on kitsu if hulu has it
    kitsu_anime.episodes.each do |ep|
      next unless hulu_ep_hash.key?(ep.number)
      Mapping.where(
        item: ep,
        external_site: 'hulu',
        external_id: hulu_ep_hash[ep.number][:site_id]
      ).first_or_create
    end
  end

  def guid
    ENV['HULU_GUID']
  end
end
