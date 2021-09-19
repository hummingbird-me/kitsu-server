class RemovePaperclipColumnsFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :avatar_file_name
    remove_column :users, :avatar_content_type
    remove_column :users, :avatar_file_size
    remove_column :users, :avatar_updated_at
    remove_column :users, :avatar_processing
    remove_column :users, :avatar_meta
    remove_column :users, :cover_image_file_name
    remove_column :users, :cover_image_content_type
    remove_column :users, :cover_image_file_size
    remove_column :users, :cover_image_updated_at
    remove_column :users, :cover_image_processing
    remove_column :users, :cover_image_meta
  end
end
