require_dependency 'counter_cache_resets'

class FillReactionsCounterCache < ActiveRecord::Migration
  disable_ddl_transaction!

  def change
    CounterCacheResets.sql_for(User, :media_reactions, where: 'deleted_at IS NULL').each { |sql| execute sql }
  end
end
