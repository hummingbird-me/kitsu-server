class CreateSiteAnnouncementViews < ActiveRecord::Migration[5.2]
  def change
    create_table :site_announcement_views do |t|
      t.references :site_announcement, null: false
      t.references :user, null: false
      t.datetime :seen_at
      t.datetime :read_at
      t.index %i[site_announcement_id user_id],
        unique: true,
        name: 'index_site_announcements_by_user_id'
    end
  end
end
