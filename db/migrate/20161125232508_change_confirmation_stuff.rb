class ChangeConfirmationStuff < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :previous_email, :string
    remove_column :users, :unconfirmed_email
  end
end
