class FillLibraryEntryOnStories < ActiveRecord::Migration
  def change
    execute <<-SQL.squish
      UPDATE stories s
      SET library_entry_id = (
        SELECT le.id
        FROM library_entries le
        WHERE le.media_type = s.target_type
        AND le.media_id = s.target_id
        AND le.user_id = s.user_id
      )
      WHERE s.library_entry_id IS NULL
      AND s.story_type = 'media_story'
    SQL
  end
end
