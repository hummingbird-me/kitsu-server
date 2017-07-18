class MangaTimelineFeed < InterestTimelineFeed
  def initialize(user_id)
    super(user_id, 'Manga')
  end

  delegate :follows_for_progress, to: :ChapterFeed
end
