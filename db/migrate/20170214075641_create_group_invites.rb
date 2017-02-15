class CreateGroupInvites < ActiveRecord::Migration
  def change
    create_table :group_invites do |t|
      t.references :group, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.references :sender, index: true, null: false
      t.foreign_key :users, column: :sender_id

      t.timestamps null: false
    end
  end
end
