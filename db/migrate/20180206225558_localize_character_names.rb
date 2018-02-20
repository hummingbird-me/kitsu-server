require 'update_in_batches'

class LocalizeCharacterNames < ActiveRecord::Migration
  using UpdateInBatches

  def change
    Anime.logger = Logger.new(STDERR)
    # Add names hash, canonical_name string, other_names array
    change_table :characters do |t|
      t.jsonb :names
      t.string :canonical_name
      t.string :other_names, array: true
    end

    # Add column defaults
    change_column_default :characters, :names, {}
    change_column_default :characters, :other_names, []

    # Commit transaction
    commit_db_transaction

    # Backfill
    Character.all.update_in_batches(<<-SQL)
      names = json_build_object('en', name)::jsonb,
      canonical_name = 'en',
      other_names = ARRAY[]::varchar[]
    SQL

    # Set non-nullable
    change_column_null :characters, :names, false
    change_column_null :characters, :canonical_name, false
    change_column_null :characters, :other_names, false
  end
end
