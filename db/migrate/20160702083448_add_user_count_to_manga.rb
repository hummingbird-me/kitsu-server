class AddUserCountToManga < ActiveRecord::Migration[4.2]
  def change
    add_column :manga, :user_count, :integer, default: 0, null: false
  end
end
