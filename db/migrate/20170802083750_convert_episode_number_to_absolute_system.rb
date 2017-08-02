require 'update_in_batches'

class ConvertEpisodeNumberToAbsoluteSystem < ActiveRecord::Migration
  using UpdateInBatches
  disable_ddl_transaction!

  def change
    execute <<-SQL.squish
      CREATE TEMPORARY TABLE absolute_numbers (id, abs) AS
        SELECT id, (row_number() OVER (
          PARTITION BY media_id, media_type
          ORDER BY season_number ASC,
                   number ASC
        )) AS abs
        FROM episodes
    SQL
    execute "CREATE INDEX ON absolute_numbers (id)"
    execute "VACUUM absolute_numbers"
    say_with_time 'Filling absolute_number column for episodes' do
      Episode.all.update_in_batches(<<-SQL.squish)
        number = (
          SELECT abs FROM absolute_numbers WHERE absolute_numbers.id = episodes.id
        )
      SQL
      execute 'DROP TABLE absolute_numbers'
    end
  end
end
