require 'update_in_batches'

class FillSlugOnUsers < ActiveRecord::Migration
  using UpdateInBatches
  disable_ddl_transaction!

  def change
    say_with_time 'Filling slugs for staff' do
      User.where(title: %w[Staff Mod]).update_in_batches('slug = name')
    end
  end
end
