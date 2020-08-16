class MyAnimeListScraper
  class MediaPage < MyAnimeListScraper
    using NodeSetContentMethod
    include SidebarKeyValueParser
    include DateRangeParser

    def call
      return unless page
      super
      import.save!
      scrape_async "#{@url}/characters"
      scrape_async "#{@url}/pics"
    end

    def import
      media.titles = media.titles.merge(titles)
      media.canonical_title ||= 'en_jp'
      media.abbreviated_titles = [*media.abbreviated_titles, *abbreviated_titles].uniq
      media.description['en'] ||= merged_synopsis
      media.genres += genres
      media.subtype = subtype
      media.poster_image = poster_image unless media.poster_image.present?
      media
    end

    def titles
      {
        en_us: sidebar_titles['English']&.content&.strip,
        en_jp: header,
        ja_jp: sidebar_titles['Japanese']&.content&.strip
      }.compact.stringify_keys
    end

    # TODO: rename abbreviated_titles to alternate_titles
    def abbreviated_titles
      sidebar_titles['Synonyms']&.content&.split(',')&.map(&:strip)
    end

    def poster_image
      URI(sidebar.at_css('[itemprop="image"]')['src'].sub(/(\.[a-z]+)\z/i, 'l\1'))
    end

    def subtype
      subtype = information['Type'].content.strip.underscore
      case subtype
      when 'tv', 'ova', 'ona' then subtype.upcase.to_sym
      else subtype.to_sym
      end
    end

    def merged_synopsis
      "#{synopsis}\n\n#{background}"
    end

    def synopsis
      text = main_sections['Synopsis'].content
      return if EMPTY_TEXT =~ text
      clean_text(text)
    end

    def background
      text = main_sections['Background'].content
      return if EMPTY_TEXT =~ text
      clean_text(text)
    end

    def genres
      Genre.where(name: information['Genres'].css('a').map(&:content))
    end

    private

    def sidebar_titles
      @sidebar_titles ||= hash_for_sidebar_section('Alternative Titles') || {}
    end

    def information
      @information ||= hash_for_sidebar_section('Information')
    end
  end
end
