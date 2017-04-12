class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :type, null: false
      t.jsonb :value
      t.timestamps null: false
    end
  end
end
