require_dependency 'update_in_batches'

class GroupUnreadFanoutService
  using UpdateInBatches

  attr_reader :group, :source_user

  def initialize(group, source_user)
    @group = group
    @source_user = source_user
  end

  def run!
    members.update_in_batches('unread_count = unread_count + 1', of: 100)
  end

  def members
    if source_user
      group.members.where.not(user_id: source_user)
    else
      group.members
    end
  end
end
