class RemovePaperclipColumnsFromUploads < ActiveRecord::Migration[5.2]
  def change
    remove_column :uploads, :content_content_type
    remove_column :uploads, :content_file_name
    remove_column :uploads, :content_file_size
    remove_column :uploads, :content_updated_at
    remove_column :uploads, :content_meta
  end
end
