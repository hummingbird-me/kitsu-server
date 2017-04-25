module DataImport
  class MangaReader
    module Extractor
      class Chapter
        attr_reader :data

        def initialize(json)
          @data = JSON.parse(json)
        end

        # {
        #   "href": "naruto/1",
        #   "name": "Uzumaki Naruto",
        #   "pages": [
        #     {
        #       "pageId": 1,
        #       "url": "http://i10.mangareader.net/naruto/1/naruto-1564773.jpg"
        #     },
        #     {
        #       "pageId": 2,
        #       "url": "http://i4.mangareader.net/naruto/1/naruto-1564774.jpg"
        #     }
        #   ]
        # }

        def title
          data['name']
        end

        def thumbnail
          data['pages'][0]['url']
        end

        def length
          data['pages'].length
        end

        def to_h
          %i[title thumbnail length]
            .map { |k|
              [k, send(k)]
            }.to_h
        end
      end
    end
  end
end
