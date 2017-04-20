class LibraryEvent < ApplicationRecord
  belongs_to :library_entry, required: true

  enum event: %i[added updated]
  enum status: LibraryEntry.statuses

  validates :event, presence: true
  validates :status, presence: true, if: :updated? # not sure if needed
end
