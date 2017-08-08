class NicoVideoEmbedder < OpenGraphEmbedder
  NICO_URL = %r{\Ahttps?://(?:www\.)?nicovideo.jp/watch/(?<id>sm\d+)}

  def match?
    NICO_URL.match(url).present?
  end

  def nico_id
    NICO_URL.match(url)['id']
  end

  def nico_embed_url
    "http://embed.nicovideo.jp/watch/#{nico_id}?autoplay=1&allowProgrammaticFullScreen=1"
  end

  def video
    super.merge(url: nico_embed_url, type: 'text/html')
  end
end
