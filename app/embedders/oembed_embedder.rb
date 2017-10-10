class OembedEmbedder < Embedder
  def page
    @page ||= Nokogiri::HTML(get(url))
  end

  def oembed_url
    page.css('link').collect(&:href).select { |e| e.include? 'oembed' }.first
  end

  def json_oembed_url
    match? ? "#{oembed_url}&format=json" : nil
  end

  def oembed_data
    JSON.parse(get(json_oembed_url))
  end

  def to_h
    oembed_data.merge(oembed_url: json_oembed_url, url: url).reject { |_k, v| v.blank? }
  end

  def match?
    !oembed_url.nil?
  end
end
