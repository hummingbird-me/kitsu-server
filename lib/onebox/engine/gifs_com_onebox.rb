module Onebox
  module Engine
    class GifsComOnebox
      include Engine

      matches_regexp(%r{https?://(?:.*\.)?gifs.com/})
      always_https

      def to_html
        escaped_url = ::Onebox::Helpers.normalize_url_for_output(@url)
        %r{https?://(?:.*\.)?gifs.com/(?:gif/)?(?:[a-z]+-)*([0-9,a-z,A-Z]+)}.match(escaped_url)
        src = "https://gifs.com/iembed/#{Regexp.last_match(1)}"

        <<-HTML
          <iframe width="480" height="270" src="#{src}" frameborder="0" scrolling="no"></iframe>
        HTML
      end
    end
  end
end
