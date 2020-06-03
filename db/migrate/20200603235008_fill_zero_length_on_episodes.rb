class FillZeroLengthOnEpisodes < ActiveRecord::Migration[5.1]
  def change
    Episode.where(length: 0).update_all(<<-SQL.squish)
      length = (SELECT episode_length FROM anime where id = episodes.media_id)
    SQL
  end
end
