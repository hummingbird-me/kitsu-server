module HTML
  class Pipeline
    class OneboxFilter < HTML::Pipeline::Filter
      WHITELISTED_FILE_TYPES = ['.gif', '.jpg', '.png', '.mov', '.mp4']
      def call
        doc.search('a.autolink').each do |a|
          url = a['href']
          file_regex = Regexp.union(WHITELISTED_FILE_TYPES)
          if file_regex === url.downcase
            preview = Onebox.preview(url, max_width: 500) rescue nil
            if preview&.to_s.present?
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
          end
        end
        doc
      end
    end
  end
end
