class CreateLibraryEntryLogs < ActiveRecord::Migration
  def change
    create_table :library_entry_logs do |t|
      t.references :linked_account, null: false, index: true
      # Copied fields from Library Entries
      # without null constraints
      t.string :media_type
      t.integer :media_id
      t.integer :progress
      t.decimal :rating, precision: 2, scale: 1
      t.integer :reconsume_count
      t.boolean :reconsuming
      t.integer :status
      t.integer :volumes_owned

      # new fields being added
      t.string :action_performed, null: false, default: 'create'
      t.integer :sync_status, null: false, default: 0
      t.text :error_message

      t.timestamps null: false
    end
  end
end
