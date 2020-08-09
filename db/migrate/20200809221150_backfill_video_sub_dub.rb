require 'update_in_batches'

class BackfillVideoSubDub < ActiveRecord::Migration[5.1]
  using UpdateInBatches
  disable_ddl_transaction!

  def change
    Video.all.update_in_batches(<<-SQL)
      subs = ARRAY[sub_lang]::varchar[],
      dubs = ARRAY[dub_lang]::varchar[]
    SQL
  end
end
