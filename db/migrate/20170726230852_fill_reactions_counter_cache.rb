class FillReactionsCounterCache < ActiveRecord::Migration
  disable_ddl_transaction!

  def change
    User.all.each { |user| User.reset_counters(user.id, :media_reactions) }
  end
end
