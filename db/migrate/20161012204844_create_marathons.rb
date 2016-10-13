class CreateMarathons < ActiveRecord::Migration
  def change
    create_table :marathons do |t|
      t.references :library_entry, foreign_key: true, null: false
      t.boolean :rewatch, null: false
      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps null: false
    end

    create_table :marathon_events do |t|
      t.references :marathon, foreign_key: true, null: false
      t.references :unit, polymorphic: true
      t.integer :event, null: false
      t.integer :status
      t.timestamps null: false
    end
  end
end
