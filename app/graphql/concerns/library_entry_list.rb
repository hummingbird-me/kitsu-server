module LibraryEntryList
  extend ActiveSupport::Concern

  included do
    field :all, Types::LibraryEntry.connection_type,
      null: false,
      description: 'All Library Entries for a specific Media'

    field :current, Types::LibraryEntry.connection_type,
      null: false,
      description: 'Library Entries for a specific Media filtered by the current status'

    field :planned, Types::LibraryEntry.connection_type,
      null: false,
      description: 'Library Entries for a specific Media filtered by the planned status'

    field :completed, Types::LibraryEntry.connection_type,
      null: false,
      description: 'Library Entries for a specific Media filtered by the completed status'

    field :on_hold, Types::LibraryEntry.connection_type,
      null: false,
      description: 'Library Entries for a specific Media filtered by the on_hold status'

    field :dropped, Types::LibraryEntry.connection_type,
      null: false,
      description: 'Library Entries for a specific Media filtered by the dropped status'
  end

  def all
    library_entries
  end

  def current
    library_entries(:current)
  end

  def planned
    library_entries(:planned)
  end

  def completed
    library_entries(:completed)
  end

  def on_hold
    library_entries(:on_hold)
  end

  def dropped
    library_entries(:dropped)
  end

  def library_entries(status = nil)
    query = { media_type: media_type, status: status }.compact
    object.library_entries.where(query)
  end
end
