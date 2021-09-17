class RemovePaperclipColumnsFromPersonAndCharacter < ActiveRecord::Migration[5.2]
  def change
    remove_column :people, :image_file_name
    remove_column :people, :image_file_size
    remove_column :people, :image_content_type
    remove_column :people, :image_updated_at
    remove_column :characters, :image_file_name
    remove_column :characters, :image_file_size
    remove_column :characters, :image_content_type
    remove_column :characters, :image_updated_at
  end
end
