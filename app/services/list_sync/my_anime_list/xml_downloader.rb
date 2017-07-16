module ListSync
  class MyAnimeList
    class XmlDownloader
      def initialize(agent, kind)
        @agent = agent
        @kind = kind
      end

      def file
        export_page = @agent.get('https://myanimelist.net/panel.php?go=export')
        result_page = export_page.form_with(method: 'POST', action: /export/) { |form|
          form['csrf_token'] = csrf_token_on(export_page)
          form.field_with(name: 'type').value = type
        }.click_button
        file_link = result_page.link_with(href: %r{/export/download\.php})
        with_download_parser { file_link.click.body_io }
      end

      private

      def with_download_parser
        default_parser = @agent.pluggable_parser['text/html']
        @agent.pluggable_parser.html = Mechanize::Download
        value = yield
        @agent.pluggable_parser.html = default_parser
        value
      end

      def type
        case @kind
        when :anime then 1
        when :manga then 2
        end
      end

      def csrf_token_on(page)
        page.search('meta[name="csrf_token"]').first['content']
      end
    end
  end
end
