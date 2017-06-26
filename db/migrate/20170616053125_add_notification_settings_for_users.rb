class AddNotificationSettingsForUsers < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    User.find_each do |user|
      all_users_notifications = []
      NotificationSetting::NOTIFICATION_TYPES.each do |st|
        all_users_notifications << {
          setting_type: st,
          user: user,
          fb_messenger_enabled: false,
          mobile_enabled: false,
          email_enabled: false
        }
      end
      NotificationSetting.create(all_users_notifications)
    end
  end
end
