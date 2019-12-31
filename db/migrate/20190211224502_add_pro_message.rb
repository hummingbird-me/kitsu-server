class AddProMessage < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :pro_message, :string
  end
end
