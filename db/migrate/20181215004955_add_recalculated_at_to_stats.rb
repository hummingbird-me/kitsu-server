class AddRecalculatedAtToStats < ActiveRecord::Migration
  def change
    add_column :stats, :recalculated_at, :datetime
    Stat.update_all('recalculated_at = created_at')
    change_column_null :stats, :recalculated_at, false
  end
end
