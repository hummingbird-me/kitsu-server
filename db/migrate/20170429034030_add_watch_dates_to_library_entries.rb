class AddWatchDatesToLibraryEntries < ActiveRecord::Migration
  def change
    change_table :library_entries do |t|
      t.timestamp :started_at
      t.timestamp :finished_at
      t.timestamp :watched_at
    end
  end
end
