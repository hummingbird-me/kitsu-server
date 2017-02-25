module Onebox
  module Engine
    class GiphyOnebox
      include Engine

      matches_regexp(%r{https?://(?:.*\.)?giphy.com/})
      always_https

      def to_html
        escaped_url = ::Onebox::Helpers.normalize_url_for_output(@url)
        %r{https?://(?:.*\.)?giphy.com/(?:media/)?(?:gifs/)?(?:[a-z]+-)*([0-9,a-z,A-Z]+)}.match(escaped_url)
        src = "https://media.giphy.com/media/#{Regexp.last_match(1)}/giphy.mp4"

        <<-HTML
          <video autoplay loop>
            <source src="#{src}" type="video/mp4">
          </video>
        HTML
      end
    end
  end
end
