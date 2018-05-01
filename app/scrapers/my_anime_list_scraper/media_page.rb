class MyAnimeListScraper
  class MediaPage < MyAnimeListScraper
    using NodeSetContentMethod
    include SidebarKeyValueParser

    def call
      super
      import.save!
      scrape_async "#{@url}/characters"
      scrape_async "#{@url}/pics"
    end

    def import
      media.titles = media.titles.merge(titles)
      media.canonical_title ||= 'en_jp'
      media.abbreviated_titles = [*media.abbreviated_titles, *abbreviated_titles].uniq
      media.synopsis ||= "#{synopsis}\n\n#{background}"
      media.genres += genres
      media.subtype ||= subtype
      media.poster_image ||= poster_image
    end

    def titles
      titles = hash_for_sidebar_section('Alternative Titles')
      {
        en_us: titles['English']&.content&.strip,
        en_jp: header,
        ja_jp: titles['Japanese']&.content&.strip
      }.compact.stringify_keys
    end

    # TODO: rename abbreviated_titles to alternate_titles
    def abbreviated_titles
      hash_for_sidebar_section('Alternative Titles')['Synonyms']&.content&.split(',')&.map(&:strip)
    end

    def poster_image
      URI(sidebar.at_css('[itemprop="image"]')['src'].sub(/(\.[a-z]+)\z/i, 'l\1'))
    end

    def subtype
      information['Type'].content.strip.underscore.to_sym
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

    def information
      @information ||= hash_for_sidebar_section('Information')
    end
  end
end
