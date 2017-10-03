class AddReactionVoteNotifSettingsToUsers < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    User.find_each do |user|
      all_users_notifications = []
      all_users_notifications << {
        setting_type: 5,
        user: user,
        fb_messenger_enabled: false,
        mobile_enabled: false,
        email_enabled: false
      }
      NotificationSetting.create(all_users_notifications)
    end
  end
end
