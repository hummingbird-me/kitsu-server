class AddNotificationSettingsForUsers < ActiveRecord::Migration
  def change
    all_users = User.all
    all_users_notifications = []
    all_users.each do |user|
      NotificationSetting::NOTIFICATION_TYPES.each do |st|
        all_users_notifications << {
          setting_type: st,
          user: user,
          fb_messenger_enabled: false,
          mobile_enabled: false,
          email_enabled: false
        }
      end
    end
    NotificationSetting.create(all_users_notifications)
  end
end
