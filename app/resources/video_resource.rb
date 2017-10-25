class VideoResource < BaseResource
  caching

  attributes :url, :available_regions, :sub_lang, :dub_lang, :embed_data

  has_one :episode
  has_one :streamer

  filters :sub_lang, :dub_lang
end
