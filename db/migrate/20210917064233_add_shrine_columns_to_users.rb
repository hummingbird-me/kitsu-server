class AddShrineColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :avatar_data, :jsonb
    add_column :users, :cover_image_data, :jsonb
  end
end
