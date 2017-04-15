class Feed
  class MangaFeed < MediaFeed
    def initialize(id)
      super('Manga', id)
    end
  end
end
