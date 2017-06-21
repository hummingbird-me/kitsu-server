class CreateNotificationSettings < ActiveRecord::Migration
  def change
    create_table :notification_settings do |t|
      t.integer :setting_type, null: false, required: true
      t.references :user, foreign_key: true, index: true, null: false
      t.boolean :email_enabled, default: true, required: true
      t.boolean :web_enabled, default: true, required: true
      t.boolean :mobile_enabled, default: true, required: true
      t.boolean :fb_messenger_enabled, default: true, required: true
      t.timestamps null: false
    end
  end
end
