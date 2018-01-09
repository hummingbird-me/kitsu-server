require 'update_in_batches'

class AddTotalLengthToMedia < ActiveRecord::Migration
  using UpdateInBatches

  def change
    add_column :anime, :total_length, :integer
    say_with_time 'Backfilling Anime#total_length' do
      Anime.all.update_in_batches(<<-SQL.squish, of: 200)
        total_length = (
          SELECT sum(length)
          FROM episodes
          WHERE media_id = anime.id
            AND episodes.number <= anime.episode_count
        )
      SQL
    end
  end
end
