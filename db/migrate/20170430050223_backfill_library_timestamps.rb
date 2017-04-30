class BackfillLibraryTimestamps < ActiveRecord::Migration

  def change
    LibraryEntry.where("progress > 0").find_in_batches do |batch|
      batch.each do |entry|
        entry.update(consumed_at: entry.updated_at)
        entry.update(finished_at: entry.updated_at) if entry.completed?
      end
    end
  end
end
