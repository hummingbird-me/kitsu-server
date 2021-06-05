class CreateWordfilters < ActiveRecord::Migration[5.2]
  def change
    create_table :wordfilters do |t|
      t.text :pattern, null: false
      t.boolean :regex_enabled, null: false, default: false
      t.integer :locations, null: false, default: 0
      t.integer :action, null: false, default: 0
      t.timestamps null: false
    end
  end
end
