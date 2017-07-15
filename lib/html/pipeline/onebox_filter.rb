module HTML
  class Pipeline
    class OneboxFilter < HTML::Pipeline::Filter
      ONEBOX_WHITELIST = [
        '.gif', '.jpg', '.jpeg', '.png', '.mov', '.mp4', '.webm',
        'gph.is', 'giphy.com', 'imgur.com'
      ].freeze
      def call
        doc.search('a.autolink').each do |a|
          url = a['href']
          file_regex = Regexp.union(ONEBOX_WHITELIST)
          next unless url.downcase =~ file_regex
          preview = Onebox.preview(url,
            max_width: 500,
            sanitize_config: Sanitize::Config::KITSU_ONEBOX) rescue nil
          next unless preview&.to_s.present?
          onebox_name = preview.send(:engine).class.onebox_name
          if onebox_name == 'whitelistedgeneric'
            onebox_name = URI.parse(url).host.split('.')[-2..-1].join('-')
          end
          preview = Nokogiri::HTML5.fragment(preview.to_s)
          a.swap <<-EOF.squish
            <div class="onebox onebox-#{onebox_name}">
              #{preview}
            </div>
          EOF
        end
        doc
      end
    end
  end
end
