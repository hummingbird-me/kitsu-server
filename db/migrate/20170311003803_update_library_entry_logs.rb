class UpdateLibraryEntryLogs < ActiveRecord::Migration
  def change
    change_column_null :library_entry_logs, :media_id, false
    change_column_null :library_entry_logs, :media_type, false
  end
end
