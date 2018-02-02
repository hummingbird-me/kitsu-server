class GiphyMediaEmbedder < OpenGraphEmbedder
  GIPHY_MEDIA_URL = %r{\Ahttps?://media\d?\.giphy\.com/media/(?<id>[^/]+)/giphy.*}i

  def match?
    GIPHY_MEDIA_URL =~ @url
  end

  def kind
    'video.gif'
  end

  private

  # Rewrite the Giphy URL from a direct media.giphy.com URL to a giphy.com URL and pull OpenGraph
  # from that URL instead!

  def giphy_id
    GIPHY_MEDIA_URL.match(@url)['id'] if match?
  end

  def url
    "https://giphy.com/gifs/#{giphy_id}" if giphy_id
  end

  def body
    get(url)
  end
end
