class AddOriginalAncestorIdToScrapes < ActiveRecord::Migration[4.2]
  def change
    add_column :scrapes, :original_ancestor_id, :integer
  end
end
