class MediaFollowService
  attr_reader :user, :media
  delegate :follows_for_progress, to: :@unit_feed_class

  def initialize(user, media)
    @user = user
    @media = media
    @klass = media.class
    @unit_feed_class = "#{@klass.unit_class.name}Feed".safe_constantize
  end

  def create(progress = nil)
    return if ignored?
    if Flipper[:airing_notifs].enabled?(User.current)
      user.notifications.follow(media.airing_feed, scrollback: 0)
    end
    follow_many([@media.feed], scrollback: 20)
    update(nil, progress)
  end

  def destroy(progress_was)
    if Flipper[:airing_notifs].enabled?(User.current)
      user.notifications.unfollow(media.airing_feed, keep_history: true)
    end
    unfollow_many([@media.feed], keep_history: false)
    update(progress_was, nil)
  end

  def update(progress_was = nil, progress = nil)
    follows_were = progress_was ? follows_for_progress(media, progress_was, limit: 4) : []
    follows = ignored? ? [] : follows_for_progress(media, progress)

    # Don't unfollow just to refollow
    follows_were -= follows
    unfollow_many(follows_were, keep_history: true) unless follows_were.empty?
    follow_many(follows, scrollback: 10) unless follows.empty?
  end

  private

  def ignored?
    MediaIgnore.where(user: user, media: media).exists?
  end

  def unfollow_many(*args)
    timelines.each { |timeline| timeline.unfollow_many(*args) }
  end

  def follow_many(*args)
    timelines.each { |timeline| timeline.follow_many(*args) }
  end

  def timelines
    [
      user.interest_timeline_for(@klass.name),
      (user.timeline if Flipper[:merged_timelines].enabled?(User.current))
    ].compact
  end
end
