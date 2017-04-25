module DataImport
  class MangaReader
    module Extractor
      class Manga
        attr_reader :data

        def initialize(json)
          @data = JSON.parse(json)
        end

        # {
        #   "name": "Naruto",
        #   "href": "naruto",
        #   "author": [
        #     "kishimoto-masashi"
        #   ],
        #   "artist": [
        #     "kishimoto-masashi"
        #   ],
        #   "status": "ongoing",
        #   "yearOfRelease": 1999,
        #   "genres": [
        #     "action",
        #     "drama",
        #     "fantasy",
        #     "martial-arts",
        #     "shounen",
        #     "super-power",
        #     "supernatural"
        #   ],
        #   "info": "Before Naruto's birth, a great demon fox had ... ninja.",
        #   "cover": "http://s3.mangareader.net/cover/naruto/naruto-l0.jpg",
        #   "lastUpdate": "2017-04-25T19:24:03.268Z",
        #   "chapters": [
        #     {
        #       "chapterId": 1,
        #       "name": "Uzumaki Naruto"
        #     },
        #     {
        #       "chapterId": 2,
        #       "name": "Ko No Ha Maru!!"
        #     },
        #   ]
        # }

        def title
          data['name']
        end

        def author
          data['author']
        end

        def artist
          data['artist']
        end

        # completed, ongoing
        def status
          data['status']
        end

        def genres
          data['genres']
        end

        def synopsis
          data['info']
        end

        def poster
          data['cover']
        end

        def chapter_count
          data['chapters'].length
        end

        def to_h
          %i[title author artist status genres synopsis poster chapter_count]
            .map { |k|
              [k, send(k)]
            }.to_h
        end
      end
    end
  end
end
