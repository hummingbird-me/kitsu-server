class CreateGroupBans < ActiveRecord::Migration
  def change
    create_table :group_bans do |t|
      t.references :group, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.references :moderator, null: false
      t.foreign_key :users, column: 'moderator_id'

      t.timestamps null: false
    end
  end
end
