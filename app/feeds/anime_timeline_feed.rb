class AnimeTimelineFeed < InterestTimelineFeed
  def initialize(user_id)
    super(user_id, 'Anime')
  end

  delegate :follows_for_progress, to: :EpisodeFeed
end
