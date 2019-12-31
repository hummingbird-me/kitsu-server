class AddFillerToUnits < ActiveRecord::Migration[4.2]
  def change
    add_column :chapters, :filler, :boolean
    add_column :episodes, :filler, :boolean
  end
end
