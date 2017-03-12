class AddNewSettingsToGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.integer :privacy, null: false, default: 0
      t.string :locale
      t.string :tags, array: true, default: [], null: false
    end
  end
end
