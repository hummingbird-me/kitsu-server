require 'update_in_batches'

class FillTimeSpentOnLibraryEntries < ActiveRecord::Migration
  disable_ddl_transaction!
  using UpdateInBatches

  def change
    execute <<-SQL.squish
      CREATE TEMPORARY TABLE library_spents AS (
        SELECT le.id, (
          SELECT sum(length)
          FROM episodes e
          WHERE int4range(0, le.progress, '(]') @> e.number
          AND le.media_id = e.media_id
          AND le.media_type = e.media_type
        ) + (a.total_length * le.reconsume_count) AS time_spent
        FROM library_entries le
        LEFT OUTER JOIN anime a
          ON le.anime_id = a.id
        WHERE le.anime_id IS NOT NULL
      )
    SQL
    execute 'CREATE INDEX ON library_spents (id)'
    execute 'VACUUM ANALYZE library_spents'
    say_with_time 'Inserting generated time_spent data' do
      LibraryEntry.all.update_in_batches <<-SQL.squish
        time_spent = COALESCE((
          SELECT time_spent
          FROM library_spents s
          WHERE s.id = library_entries.id
        ), 0)
      SQL
    end
  end
end
