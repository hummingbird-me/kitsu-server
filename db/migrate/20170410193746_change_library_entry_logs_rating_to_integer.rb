class ChangeLibraryEntryLogsRatingToInteger < ActiveRecord::Migration
  def change
    change_column :library_entry_logs, :rating, :integer
  end
end
