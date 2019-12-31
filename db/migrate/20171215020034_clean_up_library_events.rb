class CleanUpLibraryEvents < ActiveRecord::Migration[4.2]
  def up
    rename_column :library_events, :event, :kind
  end

  def down
    rename_column :library_events, :kind, :event
  end
end
