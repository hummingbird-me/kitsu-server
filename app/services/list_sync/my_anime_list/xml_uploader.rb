module ListSync
  class MyAnimeList
    class XmlUploader
      MEDIA_LINK = /(?<media>anime|manga)\.php\?id=(?<id>\d+)/

      def initialize(agent, xml)
        @agent = agent
        @xml = xml
      end

      def run!
        import_page = @agent.get('https://myanimelist.net/import.php')
        @results_page = import_page.form_with(name: 'importForm') { |form|
          form['csrf_token'] = csrf_token_on(import_page)
          form.field_with(name: 'importtype').value = '3'
          upload = form.file_upload_with(name: 'mal')
          upload.file_data = @xml
          upload.file_name = 'myanimelist.xml'
          upload.mime_type = 'application/xml'
        }.click_button
        results
      end

      def results
        return {} unless @results_page.at_css('#content .spaceit')

        # Get links for each media
        links = @results_page.css('#content .spaceit_pad a').map do |a|
          a['href']
        end
        # Extract the media type and ID from each link
        media_ids = links.map { |url| MEDIA_LINK.match(url) }
        # Group into { 'anime' => [1,2,3,4], 'manga' => [1,2,3,4] }
        media_ids.each_with_object(Hash.new { [] }) do |match, out|
          out[match['media']] += [match['id'].to_i]
        end
      end

      def results_count
        return unless @results_page.at_css('#content .spaceit')
        @results_page.at_css('#content .spaceit').text.split(':').last.to_i
      end

      def error_message
        @results_page.at_css('#content .badresult')&.text
      end

      def csrf_token_on(page)
        page.search('meta[name="csrf_token"]').first['content']
      end
    end
  end
end
