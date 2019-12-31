class CleanUpPeople < ActiveRecord::Migration[4.2]
  using UpdateInBatches

  def change
    change_table :people do |t|
      t.jsonb :names
      t.string :canonical_name
      t.string :other_names, array: true
      t.text :description
      t.date :birthday
    end

    # Add column defaults
    change_column_default :people, :names, {}
    change_column_default :people, :other_names, []

    # Commit transaction
    commit_db_transaction

    # Backfill
    Person.all.update_in_batches(<<-SQL.squish)
      names = json_build_object('en', name)::jsonb,
      canonical_name = 'en',
      other_names = ARRAY[]::varchar[]
    SQL

    # Set non-nullable
    change_column_null :people, :names, false
    change_column_null :people, :canonical_name, false
    change_column_null :people, :other_names, false
  end
end
