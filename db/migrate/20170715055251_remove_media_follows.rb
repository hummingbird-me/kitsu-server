class RemoveMediaFollows < ActiveRecord::Migration
  def change
    drop_table :media_follows
  end
end
