class MediaFollowService
  attr_reader :user, :media

  def initialize(user, media)
    @user = user
    @media = media
  end

  def create(progress)
    return if ignored?
    timeline.follow(media.feed)
    timeline.update_unit_follows(media, nil, progress)
  end

  def update(progress_was, progress)
    return if ignored?
    timeline.update_unit_follows(media, progress_was, progress)
  end

  def destroy(progress_was)
    timeline.unfollow(media.feed)
    timeline.update_unit_follows(media, progress_was, nil)
  end

  private

  def timeline
    user.interest_timeline_for(media.class.name)
  end

  def ignored?
    MediaIgnore.where(user: user, media: media).exists?
  end
end
