class AddTotalLengthToDrama < ActiveRecord::Migration
  def change
    add_column :dramas, :total_length, :integer, default: 0, null: false
  end
end
