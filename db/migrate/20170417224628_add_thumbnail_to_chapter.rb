class AddThumbnailToChapter < ActiveRecord::Migration
  def change
    add_column :chapters, :thumbnail_file_name, :string, limit: 255
    add_column :chapters, :thumbnail_content_type, :string, limit: 255
    add_column :chapters, :thumbnail_file_size, :integer
    add_column :chapters, :thumbnail_updated_at, :datetime
  end
end
