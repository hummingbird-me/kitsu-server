class AddPrimaryKeyToInstallments < ActiveRecord::Migration[4.2]
  def change
    add_column :installments, :id, :primary_key
  end
end
