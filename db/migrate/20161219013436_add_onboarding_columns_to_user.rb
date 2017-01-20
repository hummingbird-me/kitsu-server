class AddOnboardingColumnsToUser < ActiveRecord::Migration
  def change
    # Remove onboarding boolean
    remove_column :users, :onboarded

    # Profile Onboarding
    add_column :users, :profile_completed, :boolean, null: false, default: false
    User.where(<<-EOF.squish).update_all(profile_completed: true)
      ratings_count > 0 AND
      avatar_file_name IS NOT NULL AND
      cover_image_file_name IS NOT NULL AND
      length(about) > 0 AND
      favorites_count > 0
    EOF

    # Feed Onboarding
    add_column :users, :feed_completed, :boolean, null: false, default: false
    User.where(<<-EOF.squish).update_all(feed_completed: true)
      ratings_count > 5 AND
      following_count > 5 AND
      comments_count > 0 AND
      likes_given_count > 3
    EOF
  end
end
