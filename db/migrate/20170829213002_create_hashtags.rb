class CreateHashtags < ActiveRecord::Migration[4.2]
  def change
    create_table :hashtags do |t|
      t.string :name, null: false
      t.integer :kind, null: false, default: 0
      t.references :item, polymorphic: true
      t.timestamps null: false
    end
  end
end
