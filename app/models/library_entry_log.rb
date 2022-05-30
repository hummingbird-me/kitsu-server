class LibraryEntryLog < ApplicationRecord
  belongs_to :linked_account, optional: false
  belongs_to :media, polymorphic: true, optional: false

  enum sync_status: { pending: 0, success: 1, error: 2 }
  enum status: LibraryEntry.statuses

  validates :action_performed, :sync_status, presence: true

  def self.create_for(method, library_entry, linked_account_id)
    LibraryEntryLog.create!(
      media_type: library_entry.media_type,
      media_id: library_entry.media_id,
      progress: library_entry.progress,
      rating: library_entry.rating,
      reconsume_count: library_entry.reconsume_count,
      reconsuming: library_entry.reconsuming,
      status: library_entry.status,
      volumes_owned: library_entry.volumes_owned,
      # action_performed is either create, update, destroy
      action_performed: method,
      linked_account: linked_account_id
    )
  end

  # Returns a scope of records matching a provided library entry
  def self.for_entry(library_entry)
    where(
      media_type: library_entry.media_type,
      media_id: library_entry.media_id
    )
  end
end
