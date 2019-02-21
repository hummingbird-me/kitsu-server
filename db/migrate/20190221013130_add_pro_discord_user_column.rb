class AddProDiscordUserColumn < ActiveRecord::Migration
  def change
    add_column :users, :pro_discord_user, :string
  end
end
