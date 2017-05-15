class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :canonical_title, required: true, null: false
      t.integer :anidb_id, index: true
      t.integer :parent_id, index: true
      t.attachment :image
      t.string :description
      t.timestamps null: false
    end
  end
end