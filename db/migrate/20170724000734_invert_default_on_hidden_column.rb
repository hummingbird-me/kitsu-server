require 'update_in_batches'

class InvertDefaultOnHiddenColumn < ActiveRecord::Migration
  using UpdateInBatches

  def change
    change_column_default :follows, :hidden, false
    say_with_time 'Filling hidden column for Follow' do
      Follow.where(hidden: true).update_in_batches(hidden: false)
    end
    change_column_default :group_members, :hidden, false
    say_with_time 'Filling hidden column for GroupMember' do
      GroupMember.where(hidden: true).update_in_batches(hidden: false)
    end
  end
end
