require 'update_in_batches'

class FillReactionsCounterCache < ActiveRecord::Migration
  using UpdateInBatches
  disable_ddl_transaction!

  def change
    User.all.each { |user| User.reset_counters(user.id, :media_reactions) }
  end
end
