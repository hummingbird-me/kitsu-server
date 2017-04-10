require 'update_in_batches'

class AddTimeSpentToLibraryEntry < ActiveRecord::Migration
  using UpdateInBatches

  self.disable_ddl_transaction!

  def up
    add_column :library_entries, :time_spent, :integer

    say_with_time 'Filling time_spent column' do
      LibraryEntry.by_kind(:anime).update_in_batches(<<-SQL.squish)
        time_spent = COALESCE(progress * (
          SELECT episode_length
          FROM anime
          WHERE anime.id = library_entries.anime_id
        ), 0)
      SQL
    end

    say_with_time 'Filling time_spent null values' do
      LibraryEntry.where(time_spent: nil).update_in_batches(time_spent: 0)
    end

    change_column_default :library_entries, :time_spent, 0
    change_column_null :library_entries, :time_spent, false
  end

  def down
    remove_column :library_entries, :time_spent, :integer
  end
end
