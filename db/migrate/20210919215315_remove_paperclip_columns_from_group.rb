class RemovePaperclipColumnsFromGroup < ActiveRecord::Migration[5.2]
  def change
    remove_column :groups, :avatar_file_name
    remove_column :groups, :avatar_content_type
    remove_column :groups, :avatar_file_size
    remove_column :groups, :avatar_updated_at
    remove_column :groups, :avatar_processing
    remove_column :groups, :avatar_meta
    remove_column :groups, :cover_image_file_name
    remove_column :groups, :cover_image_content_type
    remove_column :groups, :cover_image_file_size
    remove_column :groups, :cover_image_updated_at
    remove_column :groups, :cover_image_meta
  end
end
