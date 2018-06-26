# Coordinates EventFollowService for bulk following/unfollowing based on the MediaIgnore life cycle
class MediaFollowService
  def initialize(user, media)
    @user = user
    @media = media
  end

  def follow
    timeline.follow_many(unit_feeds, scrollback: 3)
    timeline.follow(media_feed, scrollback: 3)
  end

  def unfollow
    timeline.unfollow_many(unit_feeds, keep_history: true)
    timeline.unfollow(media_feed, keep_history: true)
  end

  private

  def events
    LibraryEvent.where(user: @user).for_media(media: @media).followed
  end

  def units
    events.flat_map(&:units)
  end

  def unit_feeds
    units.map(&:feed)
  end

  def media_feed
    @media.feed
  end
end
