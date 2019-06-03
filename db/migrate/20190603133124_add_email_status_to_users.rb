require 'update_in_batches'

class AddEmailStatusToUsers < ActiveRecord::Migration
  using UpdateInBatches
  disable_ddl_transaction!

  def change
    add_column :users, :email_status, :integer, default: 0

    say_with_time 'Filling email status' do
      User.where.not(confirmed_at: nil).update_in_batches(email_status: 1)
    end
  end
end
