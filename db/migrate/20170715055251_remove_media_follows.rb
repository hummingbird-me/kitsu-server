class RemoveMediaFollows < ActiveRecord::Migration[4.2]
  def change
    drop_table :media_follows
  end
end
