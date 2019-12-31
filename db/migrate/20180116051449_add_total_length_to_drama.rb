class AddTotalLengthToDrama < ActiveRecord::Migration[4.2]
  def change
    add_column :dramas, :total_length, :integer, default: 0, null: false
  end
end
