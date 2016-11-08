class AddPrimaryKeyToInstallments < ActiveRecord::Migration
  def change
    add_column :installments, :id, :primary_key
  end
end
