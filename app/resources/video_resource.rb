class VideoResource < BaseResource
  caching

  attributes :url, :available_regions, :sub_lang, :dub_lang, :embed_data

  has_one :episode
  has_one :streamer

  filters :sub_lang, :dub_lang, :episode_id

  def self.records(options = {})
    country = options.dig(:context, :country)
    return super unless country.present? && country != 'XX'
    super.available_in(country)
  end
end
