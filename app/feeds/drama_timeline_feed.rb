class DramaTimelineFeed < InterestTimelineFeed
  def initialize(user_id)
    super(user_id, 'Drama')
  end

  def follow_units_for(media, progress)
    feeds = EpisodeFeed.follows_for_progress(media, progress)
    follow_many(feeds)
  end
end
