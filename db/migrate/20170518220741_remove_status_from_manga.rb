class RemoveStatusFromManga < ActiveRecord::Migration[4.2]
  def change
    remove_column :manga, :status, :integer
  end
end
