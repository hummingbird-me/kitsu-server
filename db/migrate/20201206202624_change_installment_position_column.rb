class ChangeInstallmentPositionColumn < ActiveRecord::Migration[5.1]
  def change
    change_column_null :installments, :position, true
    change_column_default :installments, :position, from: 0, to: nil
  end
end
