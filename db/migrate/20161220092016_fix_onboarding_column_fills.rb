class FixOnboardingColumnFills < ActiveRecord::Migration
  def change
    # Because the ratings_count requirement has gone up, we need to start over
    # on this one.  The other (feed_completed) is all more lenient than before,
    # so it's technically fine.
    User.update_all(profile_completed: false)
    User.where(<<-EOF.squish).update_all(profile_completed: true)
      ratings_count >= 3 AND
      avatar_file_name IS NOT NULL AND
      cover_image_file_name IS NOT NULL AND
      length(about) > 0 AND
      favorites_count > 0
    EOF
    User.where(<<-EOF.squish).update_all(feed_completed: true)
      ratings_count >= 5 AND
      following_count >= 5 AND
      comments_count > 0 AND
      likes_given_count >= 3
    EOF
  end
end
