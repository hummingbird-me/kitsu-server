require 'update_in_batches'

class FillSlugOnUsers < ActiveRecord::Migration
  using UpdateInBatches
  disable_ddl_transaction!

  def change
    say_with_time 'Filling slugs' do
      User.all.update_in_batches('slug = name')
    end
  end
end
