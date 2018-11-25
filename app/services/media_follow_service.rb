class MediaFollowService
  attr_reader :user, :media

  def initialize(user, media)
    @user = user
    @media = media
    @klass = media.class
  end

  def create
    return if ignored?

    user.notifications.follow(media.airing_feed, scrollback: 0) unless media.status == :finished
  end

  def destroy
    user.notifications.unfollow(media.airing_feed, keep_history: true)
  end

  private

  def ignored?
    MediaIgnore.where(user: user, media: media).exists?
  end
end
