class RemovePaperclipColumnsFromMedia < ActiveRecord::Migration[5.2]
  def change
    remove_column :anime, :poster_image_file_name
    remove_column :anime, :poster_image_file_size
    remove_column :anime, :poster_image_content_type
    remove_column :anime, :poster_image_updated_at
    remove_column :anime, :poster_image_meta
    remove_column :manga, :poster_image_file_name
    remove_column :manga, :poster_image_file_size
    remove_column :manga, :poster_image_content_type
    remove_column :manga, :poster_image_updated_at
    remove_column :manga, :poster_image_meta
    remove_column :dramas, :poster_image_file_name
    remove_column :dramas, :poster_image_file_size
    remove_column :dramas, :poster_image_content_type
    remove_column :dramas, :poster_image_updated_at
    remove_column :dramas, :poster_image_meta

    remove_column :anime, :cover_image_file_name
    remove_column :anime, :cover_image_file_size
    remove_column :anime, :cover_image_content_type
    remove_column :anime, :cover_image_updated_at
    remove_column :anime, :cover_image_meta
    remove_column :manga, :cover_image_file_name
    remove_column :manga, :cover_image_file_size
    remove_column :manga, :cover_image_content_type
    remove_column :manga, :cover_image_updated_at
    remove_column :manga, :cover_image_meta
    remove_column :dramas, :cover_image_file_name
    remove_column :dramas, :cover_image_file_size
    remove_column :dramas, :cover_image_content_type
    remove_column :dramas, :cover_image_updated_at
    remove_column :dramas, :cover_image_meta
  end
end
