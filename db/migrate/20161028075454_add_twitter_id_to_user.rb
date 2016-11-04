class AddTwitterIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter_id, :string
  end
end
