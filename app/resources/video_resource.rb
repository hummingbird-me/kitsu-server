class VideoResource < BaseResource
  caching

  attributes :url, :sub_lang, :dub_lang, :embed_data
  attributes :subs, :dubs, :regions
  attribute :available_regions, delegate: :regions # DEPRECATED

  has_one :episode
  has_one :streamer

  filters :sub_lang, :dub_lang, :episode_id
end
