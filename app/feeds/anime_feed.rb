class AnimeFeed < MediaFeed
  attr_reader :media

  def initialize(id)
    @media = Anime.find(id)
    super('Anime', id)
  end
end
