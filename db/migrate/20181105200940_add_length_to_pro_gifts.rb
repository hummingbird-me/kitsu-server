class AddLengthToProGifts < ActiveRecord::Migration
  def change
    add_column :pro_gifts, :length, :integer, default: 0, null: false
  end
end
