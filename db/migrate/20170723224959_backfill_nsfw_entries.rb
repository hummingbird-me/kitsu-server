require 'update_in_batches'

class BackfillNsfwEntries < ActiveRecord::Migration
  using UpdateInBatches
  disable_ddl_transaction!

  def change
    say_with_time 'Filling nsfw column for Library Entries' do
      LibraryEntry.joins(:anime).where('anime.age_rating = 3').update_in_batches(nsfw: true)
      LibraryEntry.joins(:manga).where('manga.age_rating = 3').update_in_batches(nsfw: true)
      LibraryEntry.joins(:drama).where('dramas.age_rating = 3').update_in_batches(nsfw: true)
    end
  end
end
