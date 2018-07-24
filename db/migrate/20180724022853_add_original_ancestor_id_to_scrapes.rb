class AddOriginalAncestorIdToScrapes < ActiveRecord::Migration
  def change
    add_column :scrapes, :original_ancestor_id, :integer
  end
end
