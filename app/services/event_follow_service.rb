# Incrementally updates media follows based on LibraryEvent life cycle
class EventFollowService
  # @param event [LibraryEvent] the event to manage following based on
  def initialize(event)
    @event = event
  end

  def follow
    return if media_ignored?
    timeline.follow_many(unit_feeds, scrollback: 10)
    timeline.follow(media_feed, scrollback: 10)
  end

  def unfollow
    timeline.unfollow_many(unit_feeds, keep_history: true)
    timeline.unfollow(media_feed, keep_history: true) unless media_recent?
  end

  private

  delegate :user, to: :@event
  delegate :media, to: :@event

  def units
    @event.units.order(number: :asc).last(5)
  end

  def unit_feeds
    units.map(&:feed)
  end

  def media_feed
    media.feed
  end

  def timeline
    @event.user.timeline
  end

  def media_recent?
    LibraryEvent.followed.where(user: user).for_media(media).not_ignored.progressed.present?
  end

  def media_ignored?
    MediaIgnore.where(media: media, user: user).present?
  end
end
