class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :blocked, index: true, null: false
      t.foreign_key :users, column: 'blocked_id'

      t.timestamps null: false
    end
  end
end
