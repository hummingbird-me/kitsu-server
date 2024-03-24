class GenerateFeedsForOwningModels < ActiveRecord::Migration[6.1]
  def change
    [User, Group, Anime, Manga, Drama, Episode, Chapter].each do |model|
      model.in_batches(of: 1000).update_all("feed_id = nextval('feeds_id_seq')")
      # Create all the new feed records
      execute <<~SQL.squish
        INSERT INTO feeds (id, created_at, updated_at)
        SELECT feed_id, created_at, created_at AS updated_at
        FROM #{model.table_name}
      SQL
    end
  end
end
