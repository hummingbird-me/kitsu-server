class AddRegionsToStreamingLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :streaming_links, :regions, :string, array: true, default: ["US"]
    add_index :streaming_links, :regions, using: 'GIN'
  end
end
