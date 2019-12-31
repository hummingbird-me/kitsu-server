class ChangeLibraryEntryLogsRatingToInteger < ActiveRecord::Migration[4.2]
  def change
    change_column :library_entry_logs, :rating, :integer
  end
end
