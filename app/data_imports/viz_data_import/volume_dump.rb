class VizDataImport
  class VolumeDump
    def initialize(data)
      @data = data
    end

    def save!
      return @vol if @vol
      
      @vol = Volume.where(manga: series, number: number).first_or_initialize
      if title
        @vol.titles = @vol.titles.merge(en_us: title)
        @vol.canonical_title = 'en_us'
      end
      @vol.isbn = [isbn.delete('-')]
      @vol.save
      @vol
    rescue
      p @data
      raise
    end

    def isbn
      @data['isbn']
    end

    def series
      @series ||= Mapping.guess(Manga, title: @data['series'])
    end

    def title
      @data['title'].sub(@data['series'], '').sub(/\A, /, '')
    end

    # @return [Integer] the volume number, extracted from the title
    def number
      /(\d+)/.match(title)&.[](1)&.to_i || 1
    end

    # @return [Array<VizDataImport::ChapterDump>] a list of chapter objects
    def chapters
      ChapterDump.wrap(@data['chapters'], self)
    end
  end
end
