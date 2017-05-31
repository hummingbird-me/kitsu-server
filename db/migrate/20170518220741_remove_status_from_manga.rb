class RemoveStatusFromManga < ActiveRecord::Migration
  def change
    remove_column :manga, :status, :integer
  end
end
