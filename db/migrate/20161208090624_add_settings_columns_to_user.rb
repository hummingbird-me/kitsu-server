class AddSettingsColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string
    add_column :users, :language, :string
    add_column :users, :country, :string, limit: 2
    add_column :users, :share_to_global, :boolean, default: true, null: false
  end
end
