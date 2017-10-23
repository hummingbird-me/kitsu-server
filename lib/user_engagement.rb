module UserEngagement
  module_function

  def send_inactive_notification
    inactive_users = User.includes(:notification_settings).where(
      last_sign_in_at: nil,
      never_signed_in_email_sent: false
    )
    inactive_users.each do |user|
      UserMailer.reengagement(user, 0).deliver_later
      user.inactive_email_sent = true
      user.never_signed_in_email_sent = true
      user.save
    end

    inactive_users = User.includes(:notification_settings).where(
      third_inactive_email_sent: false,
      second_inactive_email_sent: true,
      first_inactive_email_sent: true
    ).where.not(last_sign_in_at: 28.days.ago..18.days.ago)
    inactive_users.each do |user|
      UserMailer.reengagement(user, 28).deliver_later
      user.third_inactive_email_sent = true
      user.save
    end

    inactive_users = User.includes(:notification_settings).where(
      second_inactive_email_sent: false,
      first_inactive_email_sent: true
    ).where.not(last_sign_in_at: 18.days.ago..9.days.ago)
    inactive_users.each do |user|
      UserMailer.reengagement(user, 18).deliver_later
      user.second_inactive_email_sent = true
      user.save
    end

    inactive_users = User.includes(:notification_settings).where(
      first_inactive_email_sent: false
    ).where.not(last_sign_in_at: 9.days.ago..Time.now)
    inactive_users.each do |user|
      UserMailer.reengagement(user, 9).deliver_later
      user.first_inactive_email_sent = true
      user.save
    end
  end

  def send_post_likes_notification
    now_time = Time.now
    prev_time = 6.hours.ago
    inactive_users = User.includes(:notification_settings).where(
      notification_settings: {
        setting_type: 2,
        email_enabled: true
      }
    ).where.not(last_sign_in_at: prev_time..now_time)
    inactive_users.each do |user|
      meta_data = {
        'related_post_likes': []
      }
      meta_data['related_post_likes'] = PostLike.includes(:post).where(
        post: {
          user: user
        },
        created_at: prev_time..now_time
      )
      next if meta_data['related_post_likes'].empty?
      UserMailer.notification(
        user,
        2,
        meta_data['related_post_likes'].map(&:user),
        meta_data
      ).deliver_later
    end
  end

  def send_reaction_upvotes_notification
    now_time = Time.now
    prev_time = 6.hours.ago
    inactive_users = User.includes(:notification_settings).where(
      notification_settings: {
        setting_type: 2,
        email_enabled: true
      }
    ).where.not(last_sign_in_at: prev_time..now_time)
    inactive_users.each do |user|
      meta_data = {
        'related_reaction_votes': []
      }
      meta_data['related_reaction_votes'] = MediaReactionVote.includes(
        media_reaction: [:media]
      ).where(
        media_reaction: {
          user: user
        },
        created_at: prev_time..now_time
      )
      next if meta_data['related_reaction_votes'].empty?
      UserMailer.notification(
        user,
        7,
        meta_data['related_reaction_votes'].map(&:user),
        meta_data
      ).deliver_later
    end
  end

  def send_post_replies_notification
    now_time = Time.now
    prev_time = 1.hour.ago
    inactive_users = User.includes(:notification_settings).where(
      notification_settings: {
        setting_type: 1,
        email_enabled: true
      }
    ).where.not(last_sign_in_at: prev_time..now_time)
    inactive_users.each do |user|
      meta_data = {
        'related_post_replies': []
      }
      meta_data['related_post_replies'] = Comment.where(
        post: {
          user: user
        },
        created_at: prev_time..now_time
      )
      next if related_post_replies_users.empty?
      UserMailer.notification(
        user,
        3,
        meta_data['related_post_replies'].map(&:user),
        meta_data
      ).deliver_later
    end
  end

  def send_mention_notification
    now_time = Time.now
    prev_time = 15.minutes.ago
    inactive_users = User.includes(:notification_settings).where(
      notification_settings: {
        setting_type: 0,
        email_enabled: true
      }
    ).where.not(last_sign_in_at: prev_time..now_time)
    recent_profile_posts = Post.includes(:mentioned_users).where(
      created_at: prev_time..now_time
    )
    recent_comments = Comment.includes(:mentioned_users).where(
      created_at: prev_time..now_time
    )
    inactive_users.each do |user|
      meta_data = {
        'mention_posts': [],
        'mentioned_comments': []
      }
      recent_profile_posts.each do |rp|
        user_found = rp.mentioned_users.map(:id).include? user.id
        next unless user_found
        meta_data['mention_posts'] << rp
      end
      recent_comments.each do |rc|
        user_found = rc.mentioned_users.map(:id).include? user.id
        next unless user_found
        meta_data['mentioned_comments'] << rc
      end
      next if meta_data['mention_posts'].empty? && meta_data['mentioned_comments'].empty?
      UserMailer.notification(
        user,
        4,
        [
          meta_data['mention_posts'].map(&:user),
          meta_data['mentioned_comments'].map(&:user)
        ].flatten,
        meta_data
      ).deliver_later
    end
  end

  def send_new_profile_posts_notification
    now_time = Time.now
    prev_time = 15.minutes.ago
    inactive_users = User.includes(:notification_settings).where(
      notification_settings: {
        setting_type: 4,
        email_enabled: true
      }
    ).where.not(last_sign_in_at: prev_time..now_time)
    inactive_users.each do |user|
      meta_data = {
        'related_profile_posts': []
      }
      meta_data['related_profile_posts'] = Post.where(
        target_user: user,
        created_at: prev_time..now_time
      )
      next if meta_data['related_profile_posts'].empty?
      UserMailer.notification(
        user,
        6,
        meta_data['related_profile_posts'].map(&:user),
        meta_data
      ).deliver_later
    end
  end
end
