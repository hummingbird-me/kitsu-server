class CreateScrapes < ActiveRecord::Migration[4.2]
  def change
    create_table :scrapes do |t|
      t.text :target_url, null: false
      t.string :scraper_name
      t.integer :depth, null: false, default: 0
      t.integer :max_depth, null: false, default: 0
      t.references :parent
      t.integer :status, default: 0, null: false
      t.timestamps null: false
    end
  end
end
