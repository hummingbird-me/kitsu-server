class CleanUpVideos < ActiveRecord::Migration
  def change
    change_column :videos, :embed_data, :jsonb, default: {}, using: 'embed_data::json::jsonb'
    change_column_null :videos, :created_at, false
    change_column_null :videos, :updated_at, false
    change_column_null :videos, :episode_id, false
    change_column_null :videos, :streamer_id, false
    add_index :videos, :streamer_id
    add_index :videos, :sub_lang
    add_index :videos, :dub_lang
    add_index :videos, :available_regions, using: 'GIN'
  end
end
