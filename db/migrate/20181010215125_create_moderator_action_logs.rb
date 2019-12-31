class CreateModeratorActionLogs < ActiveRecord::Migration[4.2]
  def change
    create_table :moderator_action_logs do |t|
      t.references :user, null: false
      t.references :target, polymorphic: true, null: false
      t.string :verb, null: false
      t.timestamps null: false
    end
  end
end
