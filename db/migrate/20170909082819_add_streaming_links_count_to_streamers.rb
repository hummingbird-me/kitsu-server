require 'counter_cache_resets'
class AddStreamingLinksCountToStreamers < ActiveRecord::Migration[4.2]
  def change
    add_column :streamers, :streaming_links_count, :integer, null: false, default: 0
  end
end
