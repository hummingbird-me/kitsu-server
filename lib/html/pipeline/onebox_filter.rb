module HTML
  class Pipeline
    class OneboxFilter < HTML::Pipeline::Filter
      def call
        doc.search('a.autolink').each do |a|
          url = a['href']
          preview = Onebox.preview(url, max_width: 500) rescue nil
          if preview&.to_s.present?
            onebox_name = preview.send(:engine).class.onebox_name
            if onebox_name == 'whitelistedgeneric'
              onebox_name = URI.parse(url).host.split('.')[-2..-1].join('-')
            end
            preview = Nokogiri::HTML5.fragment(preview.to_s)
            a.swap <<-EOF
              <div class="onebox onebox-#{onebox_name}">
                #{preview}
              </div>
            EOF
          end
        end
        doc
      end
    end
  end
end
