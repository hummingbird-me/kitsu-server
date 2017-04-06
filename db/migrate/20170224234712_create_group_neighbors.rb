class CreateGroupNeighbors < ActiveRecord::Migration
  def change
    create_table :group_neighbors do |t|
      t.references :source, index: true, null: false
      t.references :destination, index: true, null: false
      t.foreign_key :groups, column: 'source_id'
      t.foreign_key :groups, column: 'destination_id'
      t.timestamps null: false
    end
  end
end
