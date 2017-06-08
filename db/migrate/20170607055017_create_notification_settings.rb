class CreateNotificationSettings < ActiveRecord::Migration
  def change
    create_table :notification_settings do |t|
      t.string :setting_name, null: false, required: true
      t.timestamps null: false
    end
  end
end
