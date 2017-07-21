require 'update_in_batches'

class FillDefaultHiddenOnGroupMembersAndFollows < ActiveRecord::Migration
  using UpdateInBatches
  disable_ddl_transaction!

  def change
    say_with_time 'Filling hidden column for Follow' do
      Follow.all.update_in_batches(hidden: false)
    end
    say_with_time 'Filling hidden column for GroupMember' do
      GroupMember.all.update_in_batches(hidden: false)
    end
  end
end
