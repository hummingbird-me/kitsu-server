class AddCounterToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :total_media_count, :integer, default: 0, null: false
  end
end
