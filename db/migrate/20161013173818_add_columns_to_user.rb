class AddColumnsToUser < ActiveRecord::Migration[4.2]
  def change
    change_table :users do |t|
      t.string :gender
      t.date :birthday
      t.remove :rating_system
    end
  end
end
