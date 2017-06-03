class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title, required: true, null: false
      t.string :description
      t.string :slug, null: false, index: true
      t.integer :anidb_id, index: true
      t.integer :parent_id, index: true
      t.integer :total_media_count, default: 0, null: false
      t.boolean :nsfw, default: false, null: false
      t.attachment :image
      t.timestamps null: false
    end
  end
end