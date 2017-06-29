class RenameLastLoginToVisitedAt < ActiveRecord::Migration
  def change
    rename_column :users, :last_login, :visited_at
  end
end
