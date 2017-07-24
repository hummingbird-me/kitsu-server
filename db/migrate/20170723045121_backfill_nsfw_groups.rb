require 'update_in_batches'

class BackfillNsfwGroups < ActiveRecord::Migration
  using UpdateInBatches
  disable_ddl_transaction!

  def change
    say_with_time 'Settings nsfw category for nsfw Groups' do
      Group.where(nsfw: true).update_in_batches(category_id: 9)
    end

    say_with_time 'Filling nsfw column for Groups' do
      Group.where(category_id: 9).update_in_batches(nsfw: true)
    end
  end
end
