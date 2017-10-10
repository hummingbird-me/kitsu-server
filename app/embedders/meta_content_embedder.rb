class MetaContentEmbedder < Embedder
  def page
    @page ||= Nokogiri::HTML(get(url))
  end

  def meta(key)
    page.at_css("meta[name='#{key}']")&.[]('content')
  end

  def keywords
    meta :keywords
  end

  def title
    page.at_css('title')&.[]('content')
  end

  def description
    meta :description
  end

  def site_name
    meta :author
  end

  def to_h
    {
      keywords: keywords,
      url: url,
      title: title,
      description: description,
      site_name: site_name
    }.reject { |_k, v| v.blank? }
  end

  def match?
    title.present?
  end
end
