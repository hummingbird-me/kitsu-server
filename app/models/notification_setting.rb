# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: notification_settings
#
#  id                   :integer          not null, primary key
#  email_enabled        :boolean          default(TRUE)
#  fb_messenger_enabled :boolean          default(TRUE)
#  mobile_enabled       :boolean          default(TRUE)
#  setting_type         :integer          not null
#  web_enabled          :boolean          default(TRUE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :integer          not null, indexed
#
# Indexes
#
#  index_notification_settings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_0c95e91db7  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class NotificationSetting < ApplicationRecord
  NOTIFICATION_TYPES = %i[mentions replies likes follows posts reaction_votes].freeze
  enum setting_type: NOTIFICATION_TYPES
  belongs_to :user

  def self.type_for_activity(type, stream_mentions, feed_id)
    case type
    when :follow then :follows
    when :post then :posts
    when :post_like, :comment_like then :likes
    when :media_reaction_vote then :reaction_votes
    when :comment then stream_mentions.include?(feed_id.to_i) ? :mentions : :posts
    end
  end

  def self.setup_notification_settings(user)
    NOTIFICATION_TYPES.each do |st|
      NotificationSetting.where(
        setting_type: st,
        user: user,
        fb_messenger_enabled: false,
        mobile_enabled: false,
        email_enabled: false
      ).first_or_create
    end
  end
end
