class CreateCategoryFavorites < ActiveRecord::Migration
  def change
    create_table :category_favorites do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.references :category, foreign_key: true, index: true
      t.timestamps null: false
    end
  end
end