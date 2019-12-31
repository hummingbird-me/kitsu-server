class AddTwitterIdToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :twitter_id, :string
  end
end
