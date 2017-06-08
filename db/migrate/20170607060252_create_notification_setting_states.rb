class CreateNotificationSettingStates < ActiveRecord::Migration
  def change
    create_table :notification_setting_states do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.references :notification_setting, foreign_key: true,
                                          index: true, null: false
      t.boolean :is_toggled, default: true, required: true
      t.timestamps null: false
    end
  end
end
