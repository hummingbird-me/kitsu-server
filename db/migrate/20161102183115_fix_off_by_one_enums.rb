class FixOffByOneEnums < ActiveRecord::Migration
  def change
    execute <<-SQL.squish
      UPDATE anime
      SET age_rating = age_rating - 1,
          show_type = show_type - 1
    SQL
    execute <<-SQL.squish
      UPDATE manga
      SET status = status - 1,
          manga_type = manga_type - 1
    SQL
  end
end
