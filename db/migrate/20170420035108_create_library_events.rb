class CreateLibraryEvents < ActiveRecord::Migration
  def change
    # not needed anymore, will be repalced with LibraryEvents
    drop_table(:marathon_events , if_exists: true)
    drop_table(:marathons , if_exists: true)

    create_table :library_events do |t|
      t.references :library_entry, foreign_key: true, null: false

      t.integer :event, null: false
      t.integer :status

      t.timestamps null: false
    end
  end
end
