class RenameLengthToTier < ActiveRecord::Migration
  def change
    rename_column :pro_gifts, :length, :tier
  end
end
