class RemoveOldColumnsFromQuotes < ActiveRecord::Migration[4.2]
  def change
    remove_column :quotes, :content, :text, null: false
    remove_column :quotes, :character_name, :string, limit: 255
    remove_column :quotes, :character_id, :integer
  end
end
