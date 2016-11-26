class ChangeConfirmationStuff < ActiveRecord::Migration
  def change
    add_column :users, :previous_email, :string
    remove_column :users, :unconfirmed_email
  end
end
