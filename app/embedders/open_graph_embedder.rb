class OpenGraphEmbedder < Embedder
  def page
    @page ||= Nokogiri::HTML(get(url))
  end

  def og(key)
    page.at_css("meta[property='og:#{key}']")&.[]('content')
  end

  def og_media(key)
    {
      url: og("#{key}:secure_url") || og("#{key}:url") || og(key),
      width: og("#{key}:width"),
      height: og("#{key}:height"),
      type: og("#{key}:type")
    }.compact
  end

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

  def to_h
    {
      kind: kind,
      title: title,
      description: description,
      site_name: site_name,
      image: image,
      video: video,
      audio: audio
    }.reject { |_k, v| v.blank? }
  end

  def match?
    kind.present?
  end
end
