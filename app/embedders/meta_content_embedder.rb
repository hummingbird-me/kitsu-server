class MetaContentEmbedder < Embedder
  def to_h
    {
      kind: 'link',
      url: url,
      title: title,
      description: meta['description'],
      site: meta['author']
    }.reject { |_k, v| v.blank? }
  end

  def match?
    title.present?
  end

  private

  def meta(key)
    html.at_css("meta[name='#{key}']")&.[]('content')
  end

  def title
    html.at_css('title')&.[]('content')
  end
end
