require 'update_in_batches'

class FillNewRatingsColumn < ActiveRecord::Migration
  using UpdateInBatches
  disable_ddl_transaction!
  class LibraryEntry < ActiveRecord::Base; end

  def up
    say_with_time 'Filling new_rating column' do
      LibraryEntry.all.update_in_batches('new_rating = (rating * 4)')
    end
  end

  def down
    LibraryEntry.all.update_in_batches(new_rating: nil)
  end
end
