class AddCommentThreading < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :parent_id, :integer, index: true
    add_foreign_key :comments, :comments, column: 'parent_id'
  end
end
