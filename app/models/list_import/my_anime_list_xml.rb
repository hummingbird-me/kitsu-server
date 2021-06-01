# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: list_imports
#
#  id                      :integer          not null, primary key
#  error_message           :text
#  error_trace             :text
#  input_file_content_type :string
#  input_file_file_name    :string
#  input_file_file_size    :integer
#  input_file_updated_at   :datetime
#  input_text              :text
#  progress                :integer
#  status                  :integer          default(0), not null
#  strategy                :integer          not null
#  total                   :integer
#  type                    :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer          not null
#
# rubocop:enable Metrics/LineLength

class ListImport
  class MyAnimeListXML < ListImport
    include MALXMLUploader::Attachment(:input_file)

    # We need an input file for XML importing
    validates :input_text, absence: true
    validates :input_file, presence: true

    def count
      xml.css('anime, manga').count
    end

    def each
      xml.css('anime, manga').each do |media|
        row = Row.new(media)
        yield row.media, row.data
      end
    end

    private

    def gzipped?
      input_file.mime_type.include? 'gzip'
    end

    def xml
      return @xml if @xml

      data = input_file
      data = Zlib::GzipReader.new(data) if gzipped?
      data = data.read
      # We can't fix Xinil, but we can fix his mess.
      data.scrub!                                           # Scrub encoding
      data.gsub!(/&(?!(?:amp|lt|gt|quot|apos);)/, '&amp;')  # Fix escaping

      @xml = Nokogiri::XML(data)
      @xml
    end
  end
end
