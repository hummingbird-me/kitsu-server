class AddChildCountToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :child_count, :integer, default: 0, null: false
  end
end
