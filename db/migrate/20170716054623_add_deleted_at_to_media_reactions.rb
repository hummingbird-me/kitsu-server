class AddDeletedAtToMediaReactions < ActiveRecord::Migration
  def change
    add_column :media_reactions, :deleted_at, :datetime
    add_index :media_reactions, :deleted_at
  end
end
