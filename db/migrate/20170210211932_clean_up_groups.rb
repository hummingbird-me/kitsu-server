class CleanUpGroups < ActiveRecord::Migration
  def change
    # Get rid of old trending stuff
    execute 'DROP VIEW IF EXISTS group_members_histogram CASCADE'

    # Clean up Groups
    change_table :groups do |t|
      t.text :rules
      t.text :rules_formatted
      t.remove :bio, :about_formatted
      t.rename :confirmed_members_count, :members_count
      t.boolean :nsfw, default: false, null: false
      t.index :slug, unique: true
      t.change :created_at, :datetime, null: false
      t.change :updated_at, :datetime, null: false
      t.change :avatar_processing, :boolean, null: false, default: false
    end
  end
end
