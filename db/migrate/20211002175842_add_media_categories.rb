class AddMediaCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :media_categories do |t|
      t.references :media, null: false, index: true, polymorphic: true
      t.references :category, null: false, index: true
      t.timestamps null: false
    end
  end
end
