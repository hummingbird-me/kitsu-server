class RenameVolumeToVolumeNumber < ActiveRecord::Migration[4.2]
  def change
    rename_column :chapters, :volume, :volume_number
  end
end
