class AddCategoryToGroups < ActiveRecord::Migration
  def change
    add_reference :groups, :category, index: true
    GroupCategory.create!(name: 'Misc.', id: 7)
    add_foreign_key :groups, :group_categories, column: 'category_id'
    change_column_null :groups, :category_id, false, 7 # Misc.
  end
end
