class AddPosterImageDataToMedia < ActiveRecord::Migration[5.2]
  def change
    add_column :anime, :poster_image_data, :jsonb
    add_column :manga, :poster_image_data, :jsonb
    add_column :dramas, :poster_image_data, :jsonb
  end
end
