class AddRatingSystemToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rating_system, :integer, default: 0, null: false
  end
end
