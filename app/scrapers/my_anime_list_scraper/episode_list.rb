class MyAnimeListScraper
  class EpisodeList < MyAnimeListScraper
    EPISODES_URL = %r{\Ahttps://myanimelist.net/anime/(?<id>\d+)/[^/]+/episode(?:\?.*)?\z}

    def match?
      EPISODES_URL =~ @url
    end

    def call
      super
      scrape_episodes
      scrape_next_page
    end

    def scrape_episodes
      page.css('.ascend tr.episode-list-data .episode-title a').each do |link|
        scrape_async link['href']
      end
    end

    def scrape_next_page
      scrape_async next_page_url if next_page_url
    end

    def next_page_url
      @next_page_url ||= page.at_css('.pagination > .link.current + .link')&.[]('href')
    end
  end
end
