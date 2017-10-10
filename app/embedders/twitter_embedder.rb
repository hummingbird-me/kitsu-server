class TwitterEmbedder < OpenGraphEmbedder
  def twitter(key)
    page.at_css("meta[name='twitter:#{key}']")&.[]('content')
  end

  def player_info
    {
      url: twitter('player'),
      width: twitter('player:width'),
      height: twitter('player:height')
    }.compact
  end

  def card
    twitter :card
  end

  def site
    twitter :site
  end

  def creator
    twitter :creator
  end

  def twitter_info
    {
      card: card,
      site: site,
      creator: creator,
      twitter: twitter,
      player_info: player_info
    }.reject { |_k, v| v.blank? }
  end

  def to_h
    super.merge(twitter_info)
  end

  def match?
    card.present?
  end
end
