module Onebox
  module Engine
    class ImgurOnebox
      include Engine
      include StandardEmbed

      matches_regexp(%r{https?://(?:.*\.)?imgur.com/})
      always_https

      def to_html
        return gif_html(@url) if /^.*\.(gif|mp4|webm)$/ =~ @url
        og = get_opengraph
        return video_html(og) unless Onebox::Helpers.blank?(og[:video])
        return album_html(og) if album?
        return image_html(og) unless Onebox::Helpers.blank?(og[:image])
        nil
      end

      private

      def video_html(og)
        escaped_src =
          ::Onebox::Helpers.normalize_url_for_output(og[:video_secure_url])

        <<-HTML
          <video width='#{og[:video_width]}' height='#{og[:video_height]}' #{Helpers.title_attr(og)} autoplay loop>
            <source src='#{escaped_src}' type='video/mp4'>
            <source src='#{escaped_src.gsub('mp4', 'webm')}' type='video/webm'>
          </video>
        HTML
      end

      def album_html(og)
        escaped_url = ::Onebox::Helpers.normalize_url_for_output(url)
        escaped_src = ::Onebox::Helpers.normalize_url_for_output(
          get_secure_link(og[:image])
        )

        <<-HTML
          <div class='onebox imgur-album'>
            <a href='#{escaped_url}' target='_blank'>
              <span class='outer-box' style='width:#{og[:image_width]}px'>
                <span class='inner-box'>
                  <span class='album-title'>[Album] #{og[:title]}</span>
                </span>
              </span>
              <img src='#{escaped_src}' #{Helpers.title_attr(og)} height='#{og[:image_height]}' width='#{og[:image_width]}'>
            </a>
          </div>
        HTML
      end

      def album?
        response = Typhoeus.get(
          "http://api.imgur.com/oembed.json?url=#{CGI.escape(url)}"
        ) rescue '{}'
        oembed_data =
          Onebox::Helpers.symbolize_keys(::MultiJson.load(response.body))
        imgur_data_id =
          Nokogiri::HTML(oembed_data[:html]).css('blockquote').attr('data-id')
        imgur_data_id.to_s[%r{a\/}]
      end

      def image_html(og)
        escaped_url = ::Onebox::Helpers.normalize_url_for_output(url)
        escaped_src = ::Onebox::Helpers.normalize_url_for_output(
          get_secure_link(og[:image])
        )

        <<-HTML
          <a href='#{escaped_url}' target='_blank'>
            <img src='#{escaped_src}' #{Helpers.title_attr(og)} alt='Imgur' height='#{og[:image_height]}' width='#{og[:image_width]}'>
          </a>
        HTML
      end

      def get_secure_link(link)
        secure_link = URI(link)
        secure_link.scheme = 'https'
        secure_link.to_s
      end

      def gif_html(url)
        escaped_url = ::Onebox::Helpers.normalize_url_for_output(url)
        %r{https?://(?:.*\.)?imgur.com/(?:./)?([0-9,a-z,A-Z]+)} =~ escaped_url
        src = "https://i.imgur.com/#{Regexp.last_match(1)}.mp4"

        <<-HTML
          <video autoplay loop>
            <source src='#{src}' type='video/mp4'>
            <source src='#{src.gsub('mp4', 'webm')}' type='video/webm'>
          </video>
        HTML
      end
    end
  end
end
