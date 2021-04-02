class AddProgressionOrderToFranchises < ActiveRecord::Migration[5.2]
  def change
    add_column :franchises, :progression_order, :integer, default: 0, null: false
    remove_column :franchises, :canonical_title
  end
end
