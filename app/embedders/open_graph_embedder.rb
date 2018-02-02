class OpenGraphEmbedder < Embedder
  def to_h
    {
      kind: kind,
      url: url,
      title: title,
      description: description,
      site: { name: site_name },
      image: image,
      video: video,
      audio: audio
    }.reject { |_k, v| v.blank? }
  end

  def match?
    title.present?
  end

  private

  def kind
    og :type
  end

  def title
    og :title
  end

  def description
    og :description
  end

  def site_name
    og :site_name
  end

  def image
    og_media :image
  end

  def video
    og_media :video
  end

  def audio
    og_media :audio
  end

  # Retrieve the value of an OpenGraph key from the meta tags
  # @param key [String] the key to retrieve from meta tags
  # @return [String] the value of the opengraph key
  def og(key)
    html.at_css("meta[property='og:#{key}']")&.[]('content')
  end

  # Retrieve an OpenGraph media from the meta tags on the page
  def og_media(key)
    {
      url: og("#{key}:secure_url") || og("#{key}:url") || og(key),
      width: og("#{key}:width"),
      height: og("#{key}:height"),
      type: og("#{key}:type")
    }.compact
  end
end
