class LibraryEntryLog < ApplicationRecord
  belongs_to :linked_account, required: true

  enum sync_status: %i[pending success error]
  enum status: {
    current: 1,
    planned: 2,
    completed: 3,
    on_hold: 4,
    dropped: 5
  }

  validates_presence_of :action_performed, :sync_status
end
