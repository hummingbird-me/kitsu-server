# Service to sync Hulu API with Kitsu
class HuluMappingService
  GUID = guid
  HULU_URL = 'https://distribution.hulu.com/api/v1/'.freeze

  # TODO: figure out if there is a way to offset by date? `since` is available for /assets
  def sync_series_and_episodes
    offset = 0
    limit = 10_000
    series_res = Typhoeus.get(
      "#{HULU_URL}/series?guid=#{GUID}&primary_category=animation&offset=#{offset}&limit=#{limit}"
    )
    hulu_anime = JSON.parse(series_res.body)['results']
    hulu_anime.each do |item|
      item = item.deep_symbolize_keys
      series_id = item[:id]
      title = item[:name].titleize
      puts title
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
      episode_res = Typhoeus.get(
        "#{HULU_URL}/assets?guid=#{GUID}&series_id=#{series_id}&type=episode&limit=#{limit}"
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
