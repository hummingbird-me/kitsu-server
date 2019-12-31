require 'update_in_batches'

class AddSecondsToLengths < ActiveRecord::Migration[4.2]
  using UpdateInBatches

  def change
    Anime.all.update_in_batches(<<-SQL.squish)
      episode_length = episode_length * 60,
      total_length = total_length * 60
    SQL
    Drama.all.update_in_batches(<<-SQL.squish)
      episode_length = episode_length * 60,
      total_length = total_length * 60
    SQL
    Episode.all.update_in_batches('length = length * 60')
  end
end
