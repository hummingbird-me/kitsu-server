class UpdateLibraryEntryLogs < ActiveRecord::Migration[4.2]
  def change
    change_column_null :library_entry_logs, :media_id, false
    change_column_null :library_entry_logs, :media_type, false
  end
end
