class ImageEmbedder < Embedder
  def to_h
    {
      kind: 'image',
      url: url,
      title: url,
      image: {
        url: url,
        type: content_type,
        width: image.size[0],
        height: image.size[1]
      }
    }
  end

  def match?
    content_type.present?
  end

  private

  def content_type
    case image&.type
    when :png then 'image/png'
    when :gif then 'image/gif'
    when :jpeg then 'image/jpeg'
    end
  end

  def image
    @image ||= FastImage.new(url)
  end
end
