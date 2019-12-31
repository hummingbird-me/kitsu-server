class RenameLengthToTier < ActiveRecord::Migration[4.2]
  def change
    rename_column :pro_gifts, :length, :tier
  end
end
