class MangaTimelineFeed < InterestTimelineFeed
  def initialize(user_id)
    super(user_id, 'Manga')
  end

  def follow_units_for(media, progress)
    feeds = ChapterFeed.follows_for_progress(media, progress)
    follow_many(feeds)
  end
end
