class AddUniqueTypeToStat < ActiveRecord::Migration[4.2]
  def change
    add_index :stats, %i[type user_id], unique: true
  end
end
