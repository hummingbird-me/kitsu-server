class AddMissingTimestamps < ActiveRecord::Migration
  def change
    tables = %i[
      anime_castings anime_characters anime_productions anime_staff
      drama_castings drama_characters drama_staff installments
      manga_characters manga_staff mappings media_relationships
      profile_links streamers streaming_links users_roles
    ]

    tables.each do |table|
      change_table table do |t|
        t.timestamp :created_at
        t.timestamp :updated_at
      end
    end

    change_table :group_action_logs do |t|
      t.timestamp :updated_at
    end
  end
end
