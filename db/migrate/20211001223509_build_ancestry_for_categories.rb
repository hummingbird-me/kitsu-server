class BuildAncestryForCategories < ActiveRecord::Migration[5.2]
  def change
    Category.build_ancestry_from_parent_ids!
    Category.check_ancestry_integrity!
  end
end
