class MyAnimeListScraper
  class MediaPage < MyAnimeListScraper
    include SidebarKeyValueParser

    def synopsis
      text = main_sections['Synopsis'].map(&:content).join
      return if EMPTY_TEXT =~ text
      clean_text(text)
    end

    def background
      text = main_sections['Background'].map(&:content).join
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
