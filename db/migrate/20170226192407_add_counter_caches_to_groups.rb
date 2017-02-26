class AddCounterCachesToGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.integer :leaders_count, default: 0, null: false
      t.integer :neighbors_count, default: 0, null: false
    end
  end
end
