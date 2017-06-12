namespace :engagement do
  namespace :inactive do
    desc 'Sending emails to inactive users'
    task users: :environment do
      inactive_users = User.where(
        last_sign_in_at: nil,
        never_signed_in_email_sent: true
      )
      inactive_users.each do |user|
        UserMailer.reengagement(user, 0).deliver_later
        user.inactive_email_sent = true
        user.never_signed_in_email_sent = true
        user.save
      end

      inactive_users = User.where(
        last_sign_in_at: 28.days.ago..18.days.ago,
        third_inactive_email_sent: false
      )
      inactive_users.each do |user|
        UserMailer.reengagement(user, 28).deliver_later
        user.third_inactive_email_sent = true
        user.save
      end

      inactive_users = User.where(
        last_sign_in_at: 18.days.ago..9.days.ago,
        second_inactive_email_sent: false
      )
      inactive_users.each do |user|
        UserMailer.reengagement(user, 18).deliver_later
        user.second_inactive_email_sent = true
        user.save
      end

      inactive_users = User.where(
        last_sign_in_at: 9.days.ago..Time.now,
        first_inactive_email_sent: false
      )
      inactive_users.each do |user|
        UserMailer.reengagement(user, 9).deliver_later
        user.first_inactive_email_sent = true
        user.save
      end
    end
  end
  namespace notifications: :environment do
    desc 'Sending post likes notification emails to users'
    task post_likes: :environment do
      now_time = Time.now
      prev_time = 6.hours.ago
      inactive_users = User.where(
        last_sign_in_at: prev_time..now_time
      )
      inactive_users.each do |user|
        related_post_likes_users = PostLike.where(
          post: {
            user: user
          },
          created_at: prev_time..now_time
        ).select(:user)
        next if related_post_likes_users.empty?
        UserMailer.notification(
          user,
          2,
          related_post_likes_users
        ).deliver_later
      end
    end

    desc 'Sending post replies notification emails to users'
    task post_replies: :environment do
      now_time = Time.now
      prev_time = 1.hour.ago
      inactive_users = User.where(
        last_sign_in_at: prev_time..now_time
      )
      inactive_users.each do |user|
        related_post_replies_users = Comment.where(
          post: {
            user: user
          },
          created_at: prev_time..now_time
        ).select(:user)
        next if related_post_replies_users.empty?
        UserMailer.notification(
          user,
          3,
          related_post_replies_users
        ).deliver_later
      end
    end

    desc 'Sending mention notification emails to users'
    task mentions: :environment do
    end

    desc 'Sending new profile posts notification emails to users'
    task profile_posts: :environment do
      now_time = Time.now
      prev_time = 15.minutes.ago
      inactive_users = User.where(
        last_sign_in_at: prev_time..now_time
      )
      inactive_users.each do |user|
        related_profile_posts_users = Post.where(
          target_user: user,
          created_at: prev_time..now_time
        ).select(:user)
        next if related_profile_posts_users.empty?
        UserMailer.notification(
          user,
          6,
          related_profile_posts_users
        ).deliver_later
      end
    end
  end
end
