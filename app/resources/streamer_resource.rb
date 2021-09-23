class StreamerResource < BaseResource
  attributes :site_name, :streaming_links_count

  has_many :streaming_links
  has_many :videos

  paginator :unlimited
end
