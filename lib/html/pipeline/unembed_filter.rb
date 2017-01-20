module HTML
  class Pipeline
    class UnembedFilter < Filter
      def call
        doc.search('iframe, img').each do |embed|
          href = to_href(embed['src'])
          embed.swap <<-EOF.squish
            <a href="#{href}" rel="nofollow">#{href}</a>
          EOF
        end
        doc
      end

      private

      def to_href(url)
        case url
        when %r{https?://.*\.youtube.com/embed/([^\?]+).*}
          "https://youtu.be/#{$1}"
        else url
        end
      end
    end
  end
end
