class CreateGroupPermissions < ActiveRecord::Migration
  def change
    create_table :group_permissions do |t|
      t.references :group_member, index: true, foreign_key: true, null: false
      t.integer :permission, null: false

      t.timestamps null: false
    end
  end
end
