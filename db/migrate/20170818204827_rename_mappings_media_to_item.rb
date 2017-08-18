class RenameMappingsMediaToItem < ActiveRecord::Migration
  def change
    rename_column :mappings, :media_type, :item_type
    rename_column :mappings, :media_id, :item_id
    rename_index :mappings, :index_mappings_on_external_and_media,
                 :index_mappings_on_external_and_item
  end
end
