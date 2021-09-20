class AddShrineColumnToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :content_data, :jsonb
  end
end
