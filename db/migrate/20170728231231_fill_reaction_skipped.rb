require 'update_in_batches'

class FillReactionSkipped < ActiveRecord::Migration
  using UpdateInBatches
  disable_ddl_transaction!

  def change
    LibraryEntry.all.update_in_batches(reaction_skipped: 0)
  end
end
