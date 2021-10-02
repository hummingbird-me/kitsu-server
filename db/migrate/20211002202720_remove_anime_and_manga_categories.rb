class RemoveAnimeAndMangaCategories < ActiveRecord::Migration[5.2]
  def change
    drop_table :anime_categories
    drop_table :categories_manga
  end
end
