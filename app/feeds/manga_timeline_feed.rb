class MangaTimelineFeed < InterestTimelineFeed
  def initialize(user_id)
    super(user_id, 'Manga')
  end

  def default_target
    ['interest_timeline', id]
  end

  delegate :follows_for_progress, to: :ChapterFeed
end
