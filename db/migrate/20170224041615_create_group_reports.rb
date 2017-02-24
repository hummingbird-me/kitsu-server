class CreateGroupReports < ActiveRecord::Migration
  def change
    create_table :group_reports do |t|
      t.text :explanation
      t.integer :reason, null: false
      t.integer :status, null: false, index: true, default: 0
      t.references :group, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.references :naughty, polymorphic: true, index: true, null: false
      t.references :moderator
      t.foreign_key :users, column: 'moderator_id'
      t.timestamps null: false
    end
  end
end
