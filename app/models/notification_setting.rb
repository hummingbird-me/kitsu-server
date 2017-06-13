# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: notification_settings
#
#  id                      :integer          not null, primary key
#  is_email_toggled        :boolean          default(TRUE)
#  is_fb_messenger_toggled :boolean          default(TRUE)
#  is_mobile_toggled       :boolean          default(TRUE)
#  is_web_toggled          :boolean          default(TRUE)
#  setting_type            :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer          not null, indexed
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

class NotificationSetting < ActiveRecord::Base
  NOTIFICATION_TYPES = %i[mentions replies likes follows posts]
  enum setting_type: NOTIFICATION_TYPES
  belongs_to :user

  def self.setup_notification_settings(user)
    NOTIFICATION_TYPES.each do |st|
      NotificationSetting.where(
        setting_type: st,
        user: user
      ).first_or_create
    end
  end
end
