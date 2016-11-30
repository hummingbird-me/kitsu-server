class AddRepliesCountToComments < ActiveRecord::Migration
  def change
    add_column :comments, :replies_count, :integer, default: 0, null: false
  end
end
