class UserDeletionService
  using UpdateInBatches

  attr_reader :user

  def initialize(user)
    @user = user.is_a?(User) ? user : User.find(user)
  end

  def delete
    delete_followers
    delete_following
    delete_likes
    anonymize_mod_stuff
    Post.where(target_user: user).update_all(target_user: -10)
  end

  private

  def delete_followers
    follower_ids = user.followers.select(:follower_id)

    # Update the counter caches on our followers
    User.where(id: follower_ids)
        .update_in_batches('following_count = COALESCE(following_count, 1) - 1')

    # Remove the follows from Stream
    profile_feed = ProfileFeed.new(user.id)
    feeds = follower_ids.map { |f| TimelineFeed.new(f.follower_id) }
    feeds.each { |f| f.unfollow(profile_feed) }

    # Delete all the Follow instances
    Follow.where(followed: user).delete_all
  end

  def delete_following
    following_ids = user.following.select(:followed_id)

    # Update the counter caches on the users we follow
    User.where(id: following_ids)
        .update_in_batches('followers_count = COALESCE(followers_count, 1) - 1')

    # Remove the follows from Stream
    timeline_feed = TimelineFeed.new(user.id)
    feeds = following_ids.map { |f| ProfileFeed.new(f.followed_id) }
    timeline_feed.unfollow_many(feeds)

    # Delete all the follow instances
    Follow.where(follower: user).delete_all
  end

  def delete_likes
    comment_ids = user.comment_likes.select(:comment_id)
    Comment.where(id: comment_ids).update_in_batches('likes_count = COALESCE(likes_count, 1) - 1')
    CommentLike.where(user: user).delete_all

    post_ids = user.post_likes.select(:post_id)
    Post.where(id: post_ids)
        .update_in_batches('post_likes_count = COALESCE(post_likes_count, 1) - 1')
    PostLike.where(user: user).delete_all
  end

  def anonymize_mod_stuff
    user.reports.update_all(user_id: -10)
    user.group_reports.update_all(user_id: -10)
    user.group_reports_as_moderator.update_all(user_id: -10)
    user.reports_as_moderator.update_all(user_id: -10)
    user.site_announcements.update_all(user_id: -10)
  end
end
