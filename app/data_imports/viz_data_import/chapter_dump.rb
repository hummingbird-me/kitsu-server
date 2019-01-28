class VizDataImport
  class ChapterDump
    IGNORE_CHAPTERS = [
      'Title Page',
      'Copyright Page',
      /\A[^\d]*Contents[^\d]*\z/i,
      /\A[^\d]*Characters[^\d]*\z/i,
      'Glossary',
      'Previews',
      'Halftitle Page'
    ].freeze

    def initialize(chapter, volume)
      @chapter = chapter
      @volume = volume
    end

    def save!
      return @ch if @ch

      @ch = Chapter.where(manga: @volume.series, number: number).first_or_initialize
      if title.present?
        @ch.titles['en_us'] = title
        @ch.canonical_title = 'en_us'
      end
      @ch.length = length
      @ch.volume = @volume.save!
      @ch.volume_number = @volume.number
      @ch.save!
      @ch
    rescue
      p @volume
      p @chapter
      raise
    end

    def title
      title = @chapter['name'].sub(/\A\w+\s\d+:\s+/, '')
      return if /\AChapter\s\d+/ =~ title
      return if /\A#\d+/ =~ title
      title
    end

    def number
      /(\d+)/.match(@chapter['name'])&.[](1)&.to_i
    end

    def first_page
      @chapter['start']
    end

    def last_page
      @chapter['end']
    end

    def length
      last_page - first_page if last_page
    end

    # Ignore chapters with only one page or with a blacklisted name
    def skip?
      return true if length && length <= 2
      return true if IGNORE_CHAPTERS.any? { |ig| ig === title }
      false
    end

    def self.wrap(chapters, volume)
      chapters = chapters.map.with_index do |ch, i|
        next_start = chapters.dig(i + 1, 'start')
        next ch unless next_start
        ch.merge('end' => next_start - 1)
      end
      chapters.map { |ch| ChapterDump.new(ch, volume) }
    end
  end
end
