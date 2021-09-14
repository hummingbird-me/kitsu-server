class AddCoverImageDataToMedia < ActiveRecord::Migration[5.2]
  def change
    add_column :anime, :cover_image_data, :jsonb
    add_column :manga, :cover_image_data, :jsonb
    add_column :dramas, :cover_image_data, :jsonb
  end
end
