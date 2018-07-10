class AddFillerToUnits < ActiveRecord::Migration
  def change
    add_column :chapters, :filler, :boolean
    add_column :episodes, :filler, :boolean
  end
end
