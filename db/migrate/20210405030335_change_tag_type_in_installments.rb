class ChangeTagTypeInInstallments < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    Installment.update_all(tag: nil)
    change_column :installments, :tag, :integer, using: 'tag::integer'
  end

  def down
    change_column :installments, :tag, :string
  end
end
