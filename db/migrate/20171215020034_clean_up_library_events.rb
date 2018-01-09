class CleanUpLibraryEvents < ActiveRecord::Migration
  def up
    rename_column :library_events, :event, :kind
  end

  def down
    rename_column :library_events, :kind, :event
  end
end
