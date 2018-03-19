class AddNotificationSettingsForAiring < ActiveRecord::Migration
  def change
    execute <<-SQL
      INSERT INTO notification_settings (
        user_id,
        setting_type,
        fb_messenger_enabled,
        mobile_enabled,
        email_enabled,
        web_enabled,
        created_at,
        updated_at
      )
      SELECT id, 6, 'f', 't', 't', 't', current_timestamp, current_timestamp FROM users;
    SQL
  end
end
