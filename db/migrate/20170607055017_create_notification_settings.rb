class CreateNotificationSettings < ActiveRecord::Migration
  def change
    create_table :notification_settings do |t|
      t.integer :setting_type, null: false, required: true
      t.references :user, foreign_key: true, index: true, null: false
      t.boolean :is_email_toggled, default: true, required: true
      t.boolean :is_web_toggled, default: true, required: true
      t.boolean :is_mobile_toggled, default: true, required: true
      t.boolean :is_fb_messenger_toggled, default: true, required: true
      t.timestamps null: false
    end
  end
end
