class UserDeletionService
  using UpdateInBatches

  attr_reader :user

  def initialize(user)
    @user = User.find(user) unless user.is_a?(User)
  end

  def delete
    delete_followers
    delete_following
    delete_likes
    delete_comments
    anonymize_mod_stuff
  end

  private

  def delete_followers
    follower_ids = user.followers.select(:follower_id)

    # Update the counter caches on our followers
    User.where(id: follower_ids)
        .update_in_batches('following_count = COALESCE(following_count, 1) - 1')

    # Remove the follows from Stream
    profile_feed = ProfileFeed.new(user.id)
    feeds = follower_ids.map { |id| TimelineFeed.new(id) }
    feeds.each { |f| f.unfollow(profile_feed) }

    # Delete all the Follow instances
    user.followers.delete_all
  end

  def delete_following
    following_ids = user.following.select(:followed_id)

    # Update the counter caches on the users we follow
    User.where(id: following_ids)
        .update_in_batches('followers_count = COALESCE(followers_count, 1) - 1')

    # Remove the follows from Stream
    timeline_feed = TimelineFeed.new(user.id)
    feeds = following_ids.map { |id| ProfileFeed.new(id) }
    timeline_feed.unfollow_many(feeds)

    # Delete all the follow instances
    user.following.delete_all
  end

  def delete_likes
    comment_ids = user.comment_likes.select(:comment_id)
    Comment.where(id: comment_ids).update_in_batches('likes_count = COALESCE(likes_count, 1) - 1')
    user.comment_likes.delete_all

    post_ids = user.post_likes.select(:post_id)
    Post.where(id: post_ids).update_in_batches('likes_count = COALESCE(likes_count, 1) - 1')
    user.post_likes.delete_all
  end

  def delete_comments
    parent_ids = user.comments.select(:parent_id)
    Comment.where(id: parent_ids)
           .update_in_batches('replies_count = COALESCE(replies_count, 1) - 1')

    post_ids = user.comments.where(parent_id: nil).select(:post_id)
    Post.where(id: post_ids)
        .update_in_batches('top_level_comments_count = COALESCE(top_level_comments_count, 1) - 1')

    comment_ids = user.comments.select(:id)
    Comment.where(parent_id: comment_ids).delete_all

    user.comments.delete_all
  end

  def anonymize_mod_stuff
    user.reports.update_all(user_id: -10)
    user.group_reports.update_all(user_id: -10)
    user.group_reports_as_moderator.update_all(user_id: -10)
    user.reports_as_moderator.update_all(user_id: -10)
    user.site_announcements.update_all(user_id: -10)
  end
end
