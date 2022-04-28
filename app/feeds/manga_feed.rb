class MangaFeed < MediaFeed
  attr_reader :media

  def initialize(id)
    @media = Manga.find(id)
    super('Manga', id)
  end
end
