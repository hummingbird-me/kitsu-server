require 'update_in_batches'

class FillRelativeNumberForEpisodes < ActiveRecord::Migration
  using UpdateInBatches
  disable_ddl_transaction!

  def change
    Episode.all.update_in_batches('relative_number = number')
  end
end
