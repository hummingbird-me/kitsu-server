class OembedEmbedder < Embedder
  def to_h
    {
      url: url,
      kind: kind,
      site: site,
      title: oembed_data['title'],
      image: image || thumbnail,
      video: video
    }.reject { |_k, v| v.blank? }
  end

  def match?
    oembed_url.present?
  end

  private

  # Get providers from the ProvidersList class
  delegate :providers, to: :ProvidersList

  # @return [String] the URL to get the oEmbed data
  def oembed_url
    # First try for json+oembed
    html.at_css('link[rel=alternate][type$="json+oembed"]')&.[]('href') ||
      # Look for anything ending with oembed
      html.at_css('link[rel=alternate][type$=oembed]')&.[]('href') ||
      # Check the global providers list
      providers.for_url(url)
  end

  # @return [String] the oEmbed type converted to OpenGraph type
  def kind
    case oembed_data['type']
    when 'photo' then 'image'
    else oembed_data['type']
    end
  end

  # @return [Hash] the information about the site
  def site
    {
      name: oembed_data['provider_name'],
      url: oembed_data['provider_url']
    }.compact
  end

  # @return [Hash] the oEmbed thumbnail expressed as an opengraph image
  def thumbnail
    {
      url: oembed_data['thumbnail_url'],
      width: oembed_data['thumbnail_width'],
      height: oembed_data['thumbnail_height']
    }
  end

  # @return [Hash] the oEmbed image expressed as an opengraph image
  def image
    return unless kind == 'image'
    {
      url: oembed_data['url'],
      width: oembed_data['width'],
      height: oembed_data['height']
    }
  end

  # @return [Hash, nil] the oEmbed video expressed as an opengraph video
  def video
    return unless kind == 'video'
    video_frame = Nokogiri::HTML(oembed_data['html']).at_css('iframe')
    return unless video_frame
    {
      url: video_frame['src'],
      width: video_frame['width'],
      height: video_frame['height'],
      type: 'text/html'
    }
  end

  def oembed_data
    JSON.parse(get(oembed_url))
  end
end
