class AddStreamableToVideos < ActiveRecord::Migration[5.1]
  def change
    rename_column :videos, :available_regions, :regions
    add_column :videos, :subs, :string, array: true, default: ["en"]
    add_column :videos, :dubs, :string, array: true, default: ["ja"]
  end
end
