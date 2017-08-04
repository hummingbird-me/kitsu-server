class AddReactionsCounterCacheToUser < ActiveRecord::Migration
  def change
    add_column :users, :media_reactions_count, :integer
  end
end
