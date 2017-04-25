require_dependency 'data_import/http'

module DataImport
  class MangaReader
    SCRAPER_ENDPOINT =
      'https://doodle-manga-scraper.p.mashape.com/mangareader.net'.freeze
    SCRAPER_OPTS = { 'X-Mashape-Key': ENV['MASHAPE_KEY'] }.freeze

    include DataImport::HTTP

    def manga_list
      get(SCRAPER_ENDPOINT, SCRAPER_OPTS) do |list_response|
        list = JSON.parse(list_response.body)

        list.each do |manga|
          manga_endpoint = SCRAPER_ENDPOINT + '/manga/' + manga.mangaId
          get(manga_endpoint, SCRAPER_OPTS) do |manga_response|
            manga_details = Extractor::Manga.new(manga_response).to_h.compact

            manga_guess = Mapping.guess(manga_details)

            manga_details.chapters.each do |chapter|
              chapter_endpoint = manga_endpoint + '/' + chapter.chapterId
              get(chapter_endpoint, SCRAPER_OPTS) do |chapter_response|
                chapter_details =
                  Extractor::Chapter.new(chapter_response).to_h.compact
                manga_guess.chapters.create(chapter_details)
              end
            end
          end
        end
      end
    end

    private

    def get(url, opts)
      super(url, opts)
    end
  end
end
