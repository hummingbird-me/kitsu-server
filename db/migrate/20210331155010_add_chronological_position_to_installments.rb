class AddChronologicalPositionToInstallments < ActiveRecord::Migration[5.2]
  def change
    add_column :installments, :chronological_order, :integer
    rename_column :installments, :position, :release_order
  end
end
