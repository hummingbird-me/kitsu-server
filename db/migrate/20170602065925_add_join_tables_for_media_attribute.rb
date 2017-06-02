class AddJoinTablesForMediaAttribute < ActiveRecord::Migration
  def change
    create_join_table :dramas, :media_attributes
    create_join_table :anime, :media_attributes
    create_join_table :manga, :media_attributes
  end
end
