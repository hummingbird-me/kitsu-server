class AddIndexToMappingsItem < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  def change
    create_index :mappings, %i[item_type item_id], algorithm: :concurrently
  end
end
