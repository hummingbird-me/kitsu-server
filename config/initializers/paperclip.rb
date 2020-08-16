# Ignore octet-stream type when supplied
module IgnoreOctetStream
  # Hook onto Paperclip::MediaTypeSpoofDetector to ignore octet streams while MIME-spoof checking
  module SpoofDetector
    def supplied_content_type
      super unless @content_type == 'application/octet-stream'
    end

    def supplied_media_type
      super unless @content_type == 'application/octet-stream'
    end
  end

  # Hook onto Paperclip::UriAdapter to save the detected MIME if the supplied MIME is an octet
  # stream
  module Download
    def initialize(target, *)
      super
      if content_type == 'application/octet-stream' || content_type.blank?
        self.content_type = Paperclip::ContentTypeDetector.new(@tempfile.path).detect
      end
    rescue OpenURI::HTTPError
      Rails.logger.warn("PAPERCLIP REQUEST FAILED: #{target}")
      @nulled = true
    end

    def nil?
      @nulled || super
    end
  end
end

module PaperclipBlurhash
  def blurhash
    return unless instance.respond_to?(:"#{name}_meta") && instance_read(:meta)

    if (meta = meta_decode(instance_read(:meta)))
      meta[:blurhash]
    end
  end

  private

  def populate_meta(queue)
    meta = super(queue)

    original = queue[:original]
    return meta unless original.is_a?(String) || original.respond_to?(:path)
    path = original.respond_to?(:path) ? original.path : original

    # Scale down so we don't have as much data to fuck with
    image = MiniMagick::Image.open(path)
    image.resize '600x600>'
    pixels = image.get_pixels.flatten

    # Blurhash looks like shit below 3 or above 6 in any dimension
    blurhash_size = image.dimensions.map do |x|
      (x.to_f / 100).floor.clamp(3, 6)
    end

    meta[:blurhash] = Blurhash.encode(
      image.width,
      image.height,
      pixels,
      x_comp: blurhash_size[0],
      y_comp: blurhash_size[1]
    )

    meta
  end
end

Paperclip::Attachment.prepend(PaperclipBlurhash)
Paperclip::MediaTypeSpoofDetector.prepend(IgnoreOctetStream::SpoofDetector)
Paperclip::UriAdapter.prepend(IgnoreOctetStream::Download)

Paperclip::UriAdapter.register
Paperclip::DataUriAdapter.register
Paperclip::HttpUrlProxyAdapter.register
