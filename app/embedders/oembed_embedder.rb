class OembedEmbedder < Embedder
  # Get providers from the ProvidersList class
  delegate :providers, to: :ProvidersList

  # @return [String] the URL to get the oEmbed data
  def oembed_url
    # First try for json+oembed
    html.at_css('link[rel=alternate][type$="json+oembed"]')&.href ||
      # Look for anything ending with oembed
      html.at_css('link[rel=alternate][type$=oembed]')&.href ||
      # Check the global providers list
      providers.for_url(url)
  end

  def oembed_data
    JSON.parse(get(oembed_url))
  end

  def to_h
    oembed_data.merge(url: url).reject { |_k, v| v.blank? }
  end

  def match?
    oembed_url.present?
  end
end
