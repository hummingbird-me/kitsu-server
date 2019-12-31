class AddJoinTablesForCategories < ActiveRecord::Migration[4.2]
  def change
    create_join_table :categories, :dramas
    create_join_table :anime, :categories
    create_join_table :categories, :manga
  end
end
