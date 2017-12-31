require 'update_in_batches'

class AddTotalLengthToMedia < ActiveRecord::Migration
  using UpdateInBatches

  def change
    add_column :anime, :total_length, :integer
    say_with_time 'Backfilling Anime#total_length' do
      Anime.all.update_in_batches(<<-SQL.squish, of: 300)
        total_length = (SELECT sum(length) FROM episodes WHERE media_id = anime.id)
      SQL
    end
  end
end
