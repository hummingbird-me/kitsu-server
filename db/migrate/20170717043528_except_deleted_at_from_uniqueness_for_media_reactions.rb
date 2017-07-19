class ExceptDeletedAtFromUniquenessForMediaReactions < ActiveRecord::Migration
  def change
    remove_index :media_reactions, %i[media_type media_id user_id]
    add_index :media_reactions, %i[media_type media_id user_id], where: 'deleted_at IS NULL', unique: true
  end
end
