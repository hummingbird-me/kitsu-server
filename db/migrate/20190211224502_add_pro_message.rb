class AddProMessage < ActiveRecord::Migration
  def change
    add_column :users, :pro_message, :string
  end
end
