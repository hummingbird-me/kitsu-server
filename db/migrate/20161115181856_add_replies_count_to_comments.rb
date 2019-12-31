class AddRepliesCountToComments < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :replies_count, :integer, default: 0, null: false
  end
end
