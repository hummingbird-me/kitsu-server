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

Paperclip::MediaTypeSpoofDetector.prepend(IgnoreOctetStream::SpoofDetector)
Paperclip::UriAdapter.prepend(IgnoreOctetStream::Download)
