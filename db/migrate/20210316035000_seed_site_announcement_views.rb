class SeedSiteAnnouncementViews < ActiveRecord::Migration[5.2]
  def up
    execute 'SET statement_timeout TO DEFAULT'
    execute <<-SQL
      INSERT INTO site_announcement_views (user_id, announcement_id)
      SELECT
        users.id AS user_id,
        site_announcements.id AS announcement_id
      FROM users
      CROSS JOIN site_announcements
      ON CONFLICT DO NOTHING;
    SQL
  end

  def down
    execute 'TRUNCATE site_announcement_views'
  end
end
