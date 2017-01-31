module HTML
  class Pipeline
    class GifFilter < Filter
      def call
        doc.search('a.autolink').each do |a|
          link = to_link(a['href'])
          a['href'] = link
          a.content = link
        end
        doc
      end

      private

      def to_link(url)
        case url
        when %r{https?://.*\.imgur.com/([^\?]+).gifv?}
          "https://imgur.com/#{Regexp.last_match(1)}"
        # this is useless until giphy supports embedding video
        when %r{https?://.*\.giphy.com/(?:media/)?([^\?]+)(?:/giphy)?.gif}
          "https://giphy.com/gifs/#{Regexp.last_match(1)}"
        when %r{https?://.*\.gifs.com/([^\?]+).gif}
          "https://gifs.com/gif/#{Regexp.last_match(1)}"
        else url
        end
      end
    end
  end
end
