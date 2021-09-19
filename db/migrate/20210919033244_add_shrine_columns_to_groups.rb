class AddShrineColumnsToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :avatar_data, :jsonb
    add_column :groups, :cover_image_data, :jsonb
  end
end
