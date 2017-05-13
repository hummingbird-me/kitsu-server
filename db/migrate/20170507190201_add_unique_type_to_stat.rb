class AddUniqueTypeToStat < ActiveRecord::Migration
  def change
    add_index :stats, %i[type user_id], unique: true
  end
end
