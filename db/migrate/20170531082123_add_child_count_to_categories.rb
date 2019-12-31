class AddChildCountToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :child_count, :integer, default: 0, null: false
  end
end
