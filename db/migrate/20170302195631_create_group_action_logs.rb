class CreateGroupActionLogs < ActiveRecord::Migration
  def change
    create_table :group_action_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, index: true, foreign_key: true
      t.string :verb, null: false
      t.references :target, null: false, polymorphic: true

      t.datetime :created_at, null: false, index: true
    end
  end
end
