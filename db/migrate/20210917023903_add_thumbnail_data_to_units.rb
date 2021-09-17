class AddThumbnailDataToUnits < ActiveRecord::Migration[5.2]
  def change
    add_column :volumes, :thumbnail_data, :jsonb
    add_column :chapters, :thumbnail_data, :jsonb
    add_column :episodes, :thumbnail_data, :jsonb
  end
end
