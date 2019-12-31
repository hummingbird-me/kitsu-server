class AddMissingProcessingColumns < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :cover_image_processing, :boolean
    add_column :anime, :cover_image_processing, :boolean
    add_column :manga, :cover_image_processing, :boolean
    add_column :dramas, :cover_image_processing, :boolean
  end
end
