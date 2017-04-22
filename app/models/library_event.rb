class LibraryEvent < ApplicationRecord
  belongs_to :library_entry, required: true
  belongs_to :user, required: true
  belongs_to :anime
  belongs_to :manga
  belongs_to :drama

  enum event: %i[added updated]
  enum status: LibraryEntry.statuses
  # changes should validate only on :update

  # remove validation of changed_data
  validates :event, presence: true

  def self.create_for(event, library_entry)
    # TODO: one edge case we might need to deal with
    # is if someone changes progress up and down
    # just to mess with it (other fields also)
    LibraryEvent.create!(
      notes: library_entry&.notes,
      nsfw: library_entry.nsfw,
      private: library_entry.private,
      progress: library_entry.progress,
      rating: library_entry&.rating,
      reconsuming: library_entry.reconsuming,
      reconsume_count: library_entry.reconsume_count,
      volumes_owned: library_entry.volumes_owned,
      time_spent: library_entry.time_spent,
      status: library_entry.status,
      # instead of polymorphic media
      anime_id: library_entry&.anime_id,
      manga_id: library_entry&.manga_id,
      drama_id: library_entry&.drama_id,
      # event is either added or updated
      event: event,
      # capture what was changed, json format
      changed_data: library_entry.changes,
      library_entry_id: library_entry.id,
      # for filtering resource
      user_id: library_entry.user_id
    )
  end
end
