class CreateSiteAnnouncementUserStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :site_announcement_user_statuses do |t|
      t.references :site_announcement, null: false
      t.references :user, null: false
      # 0 => unseen, 1 => notified, 2 => seen, 3 => cleared
      t.integer :status, null: false, default: 0

      t.timestamps
    end
    add_index :site_announcement_user_statuses, %i[site_announcement_id user_id],
      unique: true,
      name: 'index_site_announcement_user_statuses_per_user_and_announcement'
  end
end
