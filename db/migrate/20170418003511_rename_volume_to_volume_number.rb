class RenameVolumeToVolumeNumber < ActiveRecord::Migration
  def change
    rename_column :chapters, :volume, :volume_number
  end
end
