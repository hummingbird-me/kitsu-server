class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :canonical_title, required: true
      t.integer :anidb_id, index: true
      t.string :image_content_type, limit: 255
      t.string :image_file_name, limit: 255
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.hstore :titles
      t.string :description
      t.timestamps null: false
    end
  end
end