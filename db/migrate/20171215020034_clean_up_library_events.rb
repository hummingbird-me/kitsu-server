class CleanUpLibraryEvents < ActiveRecord::Migration
  REMOVE_COLUMNS = %w[
    id nsfw reconsuming
    anime_id manga_id drama_id media_type media_id user_id
    created_at updated_at progressed_at started_at finished_at
  ].freeze

  class LibraryEvent < ActiveRecord::Base
    enum event: {
      progressed: 0,
      updated: 1,
      reacted: 2,
      rated: 3
    }
  end

  def up
    LibraryEvent.find_each do |le|
      le.update_column(:changed_data, le.changed_data.except(*REMOVE_COLUMNS))
    end
    LibraryEvent.where("changed_data = '{}'").delete_all
    LibraryEvent.update_all(event: -1)
    LibraryEvent.where("changed_data ? 'progress'").update_all(event: 0)
    LibraryEvent.where("changed_data ? 'status'").update_all(event: 1)
    LibraryEvent.where("changed_data ? 'rating'").update_all(event: 3)
    rename_column :library_events, :event, :kind
  end

  def down
    rename_column :library_events, :kind, :event
  end
end
