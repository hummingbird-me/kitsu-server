class AddAncestryToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :ancestry, :string, collation: 'POSIX'
    add_index :categories, :ancestry, opclass: :text_pattern_ops
  end
end
