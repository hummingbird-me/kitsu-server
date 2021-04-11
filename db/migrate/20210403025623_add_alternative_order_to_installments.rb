class AddAlternativeOrderToInstallments < ActiveRecord::Migration[5.2]
  def change
    add_column :installments, :alternative_order, :integer
    rename_column :installments, :position, :release_order
  end
end
