class ListImport
  class TaigaXML < ListImport
    validates :input_text, absence: true
    has_attached_file :input_file
    validates_attachment :input_file, content_type: {
      content_type: %w[application/xml]
    }, presence: true

    def count
      xml.css('library anime').count
    end

    def each
      xml.css('library anime').each do |anime|
        row = Row.new(anime)
        yield row.media, row.data
      end
    end

    private

    def xml
      @xml ||= Nokogiri::XML.fragment(open(input_file.url).read)
    end
  end
end
