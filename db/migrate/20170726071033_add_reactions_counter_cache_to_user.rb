class AddReactionsCounterCacheToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :media_reactions_count, :integer
  end
end
