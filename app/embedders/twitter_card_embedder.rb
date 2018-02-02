class TwitterCardEmbedder < Embedder
  def to_h
    {
      kind: kind,
      url: url,
      title: card('title'),
      description: card['description'],
      site: {
        name: card('site')
      },
      image: image,
      video: video
    }.reject { |_k, v| v.blank? }
  end

  def match?
    kind.present?
  end

  private

  def card(key)
    html.at_css("meta[name='twitter:#{key}']")&.[]('content')
  end

  def video
    {
      url: card('player:stream') || card('player'),
      width: card('player:width'),
      height: card('player:height'),
      type: card('player:stream:content_type')
    }.compact
  end

  def image
    {
      url: card('image'),
      alt: card('alt')
    }.compact
  end

  def kind
    case card('card')
    when /\Asummary/ then 'link'
    when 'player' then 'video'
    when 'app' then nil
    end
  end
end
