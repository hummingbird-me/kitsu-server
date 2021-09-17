class RemovePaperclipColumnsFromUnits < ActiveRecord::Migration[5.2]
  def change
    remove_column :episodes, :thumbnail_file_name
    remove_column :episodes, :thumbnail_file_size
    remove_column :episodes, :thumbnail_content_type
    remove_column :episodes, :thumbnail_updated_at
    remove_column :episodes, :thumbnail_meta
    remove_column :chapters, :thumbnail_file_name
    remove_column :chapters, :thumbnail_file_size
    remove_column :chapters, :thumbnail_content_type
    remove_column :chapters, :thumbnail_updated_at
    remove_column :chapters, :thumbnail_meta
    remove_column :volumes, :thumbnail_file_name
    remove_column :volumes, :thumbnail_file_size
    remove_column :volumes, :thumbnail_content_type
    remove_column :volumes, :thumbnail_updated_at
  end
end
