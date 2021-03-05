class AddStartAndEndToSiteAnnouncements < ActiveRecord::Migration[5.2]
  def change
    add_column :site_announcements, :show_at, :datetime,
      null: false,
      default: -> { 'CURRENT_TIMESTAMP' }
    add_column :site_announcements, :hide_at, :datetime
  end
end
