class AddProDiscordUserColumn < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :pro_discord_user, :string
  end
end
