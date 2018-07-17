class MyAnimeListScraper
  class CastList < MyAnimeListScraper
    using NodeSetContentMethod
    CAST_LIST_URL = %r{\Ahttps://myanimelist.net/anime/(?<anime>\d+)/[^/]+/characters\z}

    def call
      super
      scrape_async(*character_urls)
      scrape_async(*people_urls)
    end

    def match?
      CAST_LIST_URL =~ @url
    end

    private

    def character_urls
      main.css("a[href*='/character/']").map { |a| a['href'] }.uniq
    end

    def people_urls
      main.css("a[href*='/people/']").map { |a| a['href'] }.uniq
    end
  end
end
